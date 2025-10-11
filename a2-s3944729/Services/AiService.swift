//
//  AiService.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 24/8/2025.
//

import Foundation

/// Module that is responsible for communication between the app and Google Gemini for retrieving AI responses.
class AiService {
    static private let API_KEY = getApiKey()
    static private let MAX_RECIPES = 3
    static private let AI_RECIPE_SCHEMA: [String: Any] = [
        "type": "array",
        "items": [
            "type": "object",
            "properties": [
                "name": ["type": "string"],
                "estimatedTime": ["type": "string"],
                "ingredients": [
                    "type": "array",
                    "items": [
                        "type": "object",
                        "properties": [
                            "name": ["type": "string"],
                            "quantity": ["type": "integer"],
                            "quantityMassUnit": [
                                "type": "string",
                                "enum": ["mL", "L", "g", "kg"]
                            ]
                        ],
                        "required": ["name", "quantity"]
                    ]
                ],
                "instructions": [
                    "type": "array",
                    "items": [
                        "type": "object",
                        "properties": [
                            "instruction": ["type": "string"],
                            "timer": ["type": "integer"],
                        ],
                        "required": ["instruction", "timer"]
                    ]
                ]
            ],
            "required": ["name", "estimatedTime", "ingredients", "instructions"]
        ]
    ]
    
    static private let AI_STEP_CLARIFICATION_SCHEMA: [String: Any] = [
        "type": "object",
        "properties": [
            "clarification": ["type": "string"],
        ],
        "required": ["clarification"]
    ]
    
    private let session: NetworkSession
    
    enum AiServiceError: Error {
        case unknownError
    }
    
    init(session: NetworkSession) {
        self.session = session
    }
    
    private struct GeminiResponse: Decodable {
        let candidates: [Candidate]
    }
    
    private struct Candidate: Decodable {
        let content: Content
    }
    
    private struct Content: Decodable {
        let parts: [Part]
    }
    
    private struct Part: Decodable {
        let text: String
    }
    
    static private func getApiKey() -> String {
        let path = Bundle.main.path(forResource: "Secrets", ofType: "plist")
        if path == nil {
            fatalError("Failed to load AI Service API key from secrets file")
        }
        
        let dict = NSDictionary(contentsOfFile: path!)
        if dict == nil {
            fatalError("Failed to load AI Service API key from secrets file")
        }
        
        let key = dict!["AI_SERVICE_API_KEY"]
        if key == nil {
            fatalError("Failed to load AI Service API key from secrets file")
        }
        return String(describing: key!)
    }
    
    /// Debug function that neatly prints the given list of recipes, allowing us to see what the recipes look like
    private func prettyPrintRecipes(recipes: [Recipe]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        if let data = try? encoder.encode(recipes),
           let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
        }
    }
    
    private func extractJsonDataFromResponseData(data: Data) -> Data? {
        do {
            // Decode outer Gemini response
            let response = try JSONDecoder().decode(GeminiResponse.self, from: data)
            
            // Ensure there is only one candidate
            if response.candidates.count != 1 {
                print("Failed to JSON data: unexpected number of candidates")
                return nil
            }
            
            // Ensure there is only one candidate part
            if response.candidates[0].content.parts.count != 1 {
                print("Failed to JSON data: unexpected number of parts")
                return nil
            }
            
            let jsonString = response.candidates[0].content.parts[0].text
            let jsonData = jsonString.data(using: .utf8)
            
            if jsonData == nil {
                print("Failed to JSON data: json data is nil")
                return nil
            }
            return jsonData
        } catch {
            print("Failed to JSON data: \(error)")
        }
        return nil
    }
    
    /// Returns a list of recipes from the given response data
    private func extractRecipesFromResponseData(data: Data) -> [Recipe] {
        do {
            // Decode JSON data to list of recipes
            let recipes = try JSONDecoder().decode([Recipe].self, from: data)
            
            print("Recipes extracted successfully:")
            prettyPrintRecipes(recipes: recipes)
            return recipes
        } catch {
            print("Failed to extract recipes: \(error)")
        }
        return []
    }
    
    /// Converts the given list of ingredients to a string that lists all of the ingredients.
    private func ingredientListToString(ingredients: [Ingredient]) -> String {
        var ingredientsString = ""
        
        for i in 0...ingredients.count - 1 {
            let ingredient = ingredients[i]
            let ingredientString = "\(ingredient.quantity)\(ingredient.quantityMassUnit ?? "") \(ingredient.ingredientType.name)"
            ingredientsString += ingredientString
            
            if i != ingredients.count - 1 {
                ingredientsString += ", "
            }
        }
        
        return ingredientsString
    }
    
    func getAiResponse(prompt: String, responseSchema: [String: Any]) async -> Data? {
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=\(AiService.API_KEY)") else {
            fatalError("Invalid URL")
        }
        
        print("AI Prompt: \(prompt)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ],
            "generationConfig": [
                "responseMimeType": "application/json",
                "responseSchema": responseSchema
            ]
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (responseData, _) = try await self.session.data(for: request)
            
            if let responseString = String(data: responseData, encoding: .utf8) {
                print("Response: \(responseString)")
            }
            
            return extractJsonDataFromResponseData(data: responseData)
        } catch {
            print("Failed to get recipes: \(error)")
        }
        return nil
    }
    
    /// Generates a list of recipes that can be made with the given ingredients
    func getRecipes(ingredients: [Ingredient]) async throws -> [Recipe] {
        print("Getting recipes...")
        if ingredients.isEmpty {
            return []
        }

        let ingredientsString = ingredientListToString(ingredients: ingredients)
        let prompt = """
        Generate a maximum of \(AiService.MAX_RECIPES) recipes that contain a subset of these ingredients: [\(ingredientsString)].
        
        Timer is in seconds.
        Set timer to 0 if there is no timer.
        If no sensible recipes can be made with the above ingredients, return an empty array of recipes.
        """
        
        let responseData = await getAiResponse(prompt: prompt, responseSchema: AiService.AI_RECIPE_SCHEMA)
        
        if responseData == nil {
            print("Failed to get recipes: response data is nil")
            throw AiServiceError.unknownError
        }
        return extractRecipesFromResponseData(data: responseData!)
    }
    
    func getRecipeStepClarification(instruction: Instruction) async -> String {
        do {
            print("Getting clarification on step...")
            let prompt = """
            The user is confused on this step you generated: "\(instruction.instruction)". Please clarify it.
    """
            
            let aiResponse = await getAiResponse(prompt: prompt, responseSchema: AiService.AI_STEP_CLARIFICATION_SCHEMA)
            
            if aiResponse == nil {
                print("Failed to get step clarification: ai response is nil")
                return "Error"
            }

            let clarification = try JSONDecoder().decode(StepClarification.self, from: aiResponse!)
            return clarification.clarification
        } catch {
            print("Failed to get step clarification: \(error)")
            return "Error"
        }
    }
}

/*
 Task {
 let sampleIngredients = [
 Ingredient(name: "Egg", quantity: 5)
 ]
 let recipesList = await getRecipes(ingredients:sampleIngredients)
 
 for recipe in recipesList {
 print(recipe)
 }
 }
 */
