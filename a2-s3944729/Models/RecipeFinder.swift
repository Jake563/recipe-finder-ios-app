//
//  RecipeFinder.swift
//  a2-s3944729
//
//  Module that is responsible for communication between the app and Google Gemini for retrieving AI responses.
//
//  Created by Jake Parkinson on 24/8/2025.
//

import Foundation

private let API_KEY = "AIzaSyDYIHmKUMUbnnT3D5YOmA5P3zvmZtFEPj0"
private let MAX_RECIPES = 3
private let AI_RECIPE_SCHEMA: [String: Any] = [
    "type": "array",
    "items": [
        "type": "object",
        "properties": [
            "name": ["type": "string"],
            "ingredients": [
                "type": "array",
                "items": [
                    "type": "object",
                    "properties": [
                        "name": ["type": "string"],
                        "quantity": ["type": "integer"],
                        "quantityMassUnit": ["type": "string"]
                    ]
                ]
            ],
            "instructions": [
                "type": "array",
                "items": ["type": "string"]
            ]
        ],
        "required": ["name", "ingredients", "instructions"]
    ]
]

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

/// Debug function that neatly prints the given list of recipes, allowing us to see what the recipes look like
private func prettyPrintRecipes(recipes: [Recipe]) {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    if let data = try? encoder.encode(recipes),
       let jsonString = String(data: data, encoding: .utf8) {
        print(jsonString)
    }
}

/// Returns a list of recipes from the given response data
private func extractRecipesFromResponseData(data: Data) -> [Recipe] {
    do {
        // Decode outer Gemini response
        let response = try JSONDecoder().decode(GeminiResponse.self, from: data)
        
        // Ensure there is only one candidate
        if response.candidates.count != 1 {
            print("Failed to extract recipes: unexpected number of candidates")
            return []
        }
        
        // Ensure there is only one candidate part
        if response.candidates[0].content.parts.count != 1 {
            print("Failed to extract recipes: unexpected number of parts")
            return []
        }
        
        let jsonString = response.candidates[0].content.parts[0].text
        let jsonData = jsonString.data(using: .utf8)
        
        if jsonData == nil {
            print("Failed to extract recipes: json data is nil")
            return []
        }

        // Decode JSON data to list of recipes
        let recipes = try JSONDecoder().decode([Recipe].self, from: jsonData!)
        
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

/// Generates a list of recipes that can be made with the given ingredients
func getRecipes(ingredients: [Ingredient]) async -> [Recipe] {
    print("Getting recipes...")
    if ingredients.isEmpty {
        return []
    }
    guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=\(API_KEY)") else {
        fatalError("Invalid URL")
    }
    
    let ingredientsString = ingredientListToString(ingredients: ingredients)
    print("Ingredients string: \(ingredientsString)")
    
    let prompt = """
    Generate a maximum of \(MAX_RECIPES) recipes that contain these ingredients: \(ingredientsString). Do not include recipes that have other ingredients. Note that quantityMassUnit can be "mL", "L", "g", "kg", or nil.
    """
    
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
            "responseSchema": AI_RECIPE_SCHEMA
        ]
    ]
    request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        let (responseData, _) = try await URLSession.shared.data(for: request)
        
        if let responseString = String(data: responseData, encoding: .utf8) {
            print("Response: \(responseString)")
        }
        return extractRecipesFromResponseData(data: responseData)
    } catch {
        print("Failed to get recipes: \(error)")
    }
    return []
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
