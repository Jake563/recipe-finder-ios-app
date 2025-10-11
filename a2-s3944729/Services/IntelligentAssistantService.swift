//
//  IntelligentAssistantService.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 8/10/2025.
//

import Foundation
import SwiftData

/// Service representing the Intelligent Personal Assistant that can perform various tasks on the app based on a string input.
class IntelligentAssistantService {
    private let aiService = AiService(session: URLSession.shared)
    private let recipeService = RecipeService.getSingleRecipeService()
    
    private let ASSISTANT_CONTEXT_PROMPT = """
    You are an intelligent assistant. You can perform the following actions:
    
    add_ingredient - Adds an ingredient to the user's ingredients.
    delete_ingredient - Removes an ingredient from the user's ingredients.
    update_ingredient - Updates an ingredient in the user's ingredients.
    
    Make sure Ingredient names are lowercase and singular nouns only (e.g., "Tomatoes" -> "tomato").
    
    Provide a short, user-friendly response in the summary.
    If the request is irrelevant, set the summary to "Sorry, I cannot help with that.".
    
    Here is what the user has requested: 
    """
    
    static private let AI_ACTION_SCHEMA: [String: Any] = [
        "type": "object",
        "properties": [
            "summary": ["type": "string"],
            "actions": [
                "type": "array",
                "items": [
                    "type": "object",
                    "properties": [
                        "action": [
                            "type": "string",
                            "enum": ["add_ingredient", "delete_ingredient", "update_ingredient"]
                        ],
                        "data": [
                            "type": "object",
                            "properties": [
                                "addIngredientData": [
                                    "type": "object",
                                    "properties": [
                                        "ingredient": ["type": "string"],
                                        "quantity": ["type": "integer"],
                                        "unit": [
                                            "type": "string",
                                            "enum": ["mL", "L", "g", "kg"]
                                        ],
                                    ],
                                    "required": ["ingredient", "quantity"]
                                ],
                                "deleteIngredientData": [
                                    "type": "object",
                                    "properties": [
                                        "ingredient": ["type": "string"],
                                    ],
                                    "required": ["ingredient"]
                                ],
                                "updateIngredientData": [
                                    "type": "object",
                                    "properties": [
                                        "ingredient": ["type": "string"],
                                        "quantityDifference": ["type": "integer"],
                                        "unit": [
                                            "type": "string",
                                            "enum": ["mL", "L", "g", "kg"]
                                        ],
                                    ],
                                    "required": ["ingredient", "quantityDifference"]
                                ],
                            ]
                        ]
                    ],
                    "required": ["action", "data"]
                ]
            ]
        ],
        "required": ["summary", "actions"]
    ]
    
    private struct IntelligentAssistantResponse: Decodable {
        let summary: String
        let actions: [Action]
    }
    
    private struct Action: Decodable {
        let action: String
        let data: ActionData
    }
    
    private struct ActionData: Decodable {
        let addIngredientData: AddIngredientData?
        let deleteIngredientData: DeleteIngredientData?
        let updateIngredientData: UpdateIngredientData?
    }
    
    private struct AddIngredientData: Decodable {
        let ingredient: String
        let quantity: Int
        let unit: String?
    }
    
    private struct DeleteIngredientData: Decodable {
        let ingredient: String
    }
    
    private struct UpdateIngredientData: Decodable {
        let ingredient: String
        let quantityDifference: Int
        let unit: String?
    }
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    private func addIngredient(ingredientData: AddIngredientData) throws {
        let foundIngredientType: IngredientType? = AllIngredients.getIngredientByName(ingredientName: ingredientData.ingredient)
        if foundIngredientType == nil {
            return
        }
        
        let newIngredient = StoredIngredient(
            quantity: ingredientData.quantity,
            quantityMassUnit: ingredientData.unit,
            ingredientTypeName: foundIngredientType!.name
        )
        
        self.recipeService.requestRecipeRefresh()
        
        context.insert(newIngredient)
        try context.save()
    }
    
    private func deleteIngredient(ingredientData: DeleteIngredientData) throws {
        let userIngredients = try context.fetch(FetchDescriptor<StoredIngredient>())
        var ingredientToDelete: StoredIngredient?
        
        for userIngredient in userIngredients {
            if userIngredient.ingredientTypeName == ingredientData.ingredient {
                ingredientToDelete = userIngredient
                break
            }
        }
        
        if ingredientToDelete == nil {
            return
        }
        
        self.recipeService.requestRecipeRefresh()
        
        context.delete(ingredientToDelete!)
        try context.save()
    }
    
    private func updateIngredient(ingredientData: UpdateIngredientData) throws {
        let userIngredients = try context.fetch(FetchDescriptor<StoredIngredient>())
        var ingredientToUpdate: StoredIngredient?
        
        for userIngredient in userIngredients {
            if userIngredient.ingredientTypeName == ingredientData.ingredient {
                ingredientToUpdate = userIngredient
                break
            }
        }
        
        if ingredientToUpdate == nil {
            return
        }
        
        ingredientToUpdate!.quantity += ingredientData.quantityDifference
        ingredientToUpdate!.quantityMassUnit = ingredientData.unit
        
        self.recipeService.requestRecipeRefresh()
        
        try context.save()
    }
    
    private func performAction(action: Action) {
        if action.action == "add_ingredient" {
            if action.data.addIngredientData == nil {
                return
            }
            print("Adding ingredient: \(action.data.addIngredientData!.ingredient)")
            do {
                try addIngredient(ingredientData: action.data.addIngredientData!)
            } catch {
                print("Failed to add ingredient: \(error)")
            }
            return
        }
        
        if action.action == "delete_ingredient" {
            if action.data.deleteIngredientData == nil {
                return
            }
            print("Removing ingredient: \(action.data.deleteIngredientData!.ingredient)")
            do {
                try deleteIngredient(ingredientData: action.data.deleteIngredientData!)
            } catch {
                print("Failed to delete ingredient: \(error)")
            }
            return
        }
        
        if action.action == "update_ingredient" {
            if action.data.updateIngredientData == nil {
                return
            }
            print("Updating ingredient: \(action.data.updateIngredientData!.ingredient)")
            do {
                try updateIngredient(ingredientData: action.data.updateIngredientData!)
            } catch {
                print("Failed to update ingredient: \(error)")
            }
            return
        }
    }
    
    /// Asks the intelligent personal assistant to perform the given user request. Returns a summary of what the assistant performed,
    func performActions(userRequest: String) async -> String {
        let prompt = ASSISTANT_CONTEXT_PROMPT + userRequest
        let jsonData = await aiService.getAiResponse(prompt: prompt, responseSchema: IntelligentAssistantService.AI_ACTION_SCHEMA)
        
        if jsonData == nil {
            return "An error occured. Please try again later."
        }
        
        print(jsonData!)
        
        var intelligentAssistantResponse: IntelligentAssistantResponse?
        
        do {
            intelligentAssistantResponse = try JSONDecoder().decode(IntelligentAssistantResponse.self, from: jsonData!)
        } catch {
            print("Error decoding to intelligent assistant response: \(error)")
            return "An error occured. Please try again later."
        }
        
        if intelligentAssistantResponse == nil {
            return "An error occured. Please try again later."
        }
        
        for action in intelligentAssistantResponse!.actions {
            print("Received action: \(action)")
            print("Action: \(action.action)")
            performAction(action: action)
        }
        
        return intelligentAssistantResponse!.summary
    }
}
