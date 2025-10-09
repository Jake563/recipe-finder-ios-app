//
//  IntelligentAssistantService.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 8/10/2025.
//

import Foundation

class IntelligentAssistantService {
    private let aiService = AiService(session: URLSession.shared)
    private let ASSISTANT_CONTEXT_PROMPT = """
    You are an intelligent assistant. You can perform the following actions:
    
    add_ingredient - Adds an ingredient to the user's ingredients.
    remove_ingredient - Removes an ingredient from the user's ingredients.
    
    Here is what the user has requested: 
    """
    
    static private let AI_ACTION_SCHEMA: [String: Any] = [
        "type": "array",
        "items": [
            "type": "object",
            "properties": [
                "action": [
                    "type": "string",
                    "enum": ["add_ingredient", "remove_ingredient"]
                ],
                "data": [
                    "type": "object",
                    "properties": [
                        "ingredient": ["type": "string"],
                        "quantity": ["type": "integer"],
                        "unit": ["type": "string"]
                    ],
                    "required": ["ingredient"]
                ]
            ],
            "required": ["action", "data"]
        ]
    ]
    
    private struct Action: Decodable {
        let action: String
        let data: ActionData
    }
    
    private struct ActionData: Decodable {
        let ingredient: String
        let quantity: Double?
        let unit: String?
    }
    
    private func performAction(action: Action) {
        if action.action == "add_ingredient" {
            print("Adding ingredient: \(action.data.ingredient)")
            
            return
        }
        if action.action == "remove_ingredient" {
            print("Removing ingredient: \(action.data.ingredient)")
            return
        }
    }
    
    func performActions(userRequest: String) async -> String {
        let prompt = ASSISTANT_CONTEXT_PROMPT + userRequest
        let jsonData = await aiService.getAiResponse(prompt: prompt, responseSchema: IntelligentAssistantService.AI_ACTION_SCHEMA)
        
        if jsonData == nil {
            return "An error occured. Please try again later."
        }
        
        print(jsonData!)
        
        var actions: [Action] = []
        
        do {
            actions = try JSONDecoder().decode([Action].self, from: jsonData!)
        } catch {
            print("Error decoding to actions: \(error)")
            return "An error occured. Please try again later."
        }
        
        for action in actions {
            print("Received action: \(action)")
            print("Action: \(action.action)")
            performAction(action: action)
        }
        
        return ""
    }
}
