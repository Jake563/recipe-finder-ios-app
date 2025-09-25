//
//  AiServiceTests.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 20/9/2025.
//

import Testing
@testable import a2_s3944729
import Foundation

/// This is a mockup of the Network session, which allows unit tests to mimic what methods in Network session returns.
private struct MockNetworkSession: NetworkSession {
    var mockData: Data
    var mockResponse: URLResponse = HTTPURLResponse(
        url: URL(string: "https://test.com")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
    )!
    var shouldThrowError = false

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return (mockData, mockResponse)
    }
}

private struct GeminiResponse: Codable {
    struct Candidate: Codable {
        struct Content: Codable {
            struct Part: Codable {
                let text: String
            }
            let parts: [Part]
        }
        let content: Content
    }
    let candidates: [Candidate]
}

/// Converts the given string JSON text into a JSON data object
private func makeMockGeminiResponse(text: String) -> Data {
    let part = GeminiResponse.Candidate.Content.Part(text: text)
    let content = GeminiResponse.Candidate.Content(parts: [part])
    let candidate = GeminiResponse.Candidate(content: content)
    
    let response = GeminiResponse(candidates: [candidate])
    
    return try! JSONEncoder().encode(response)
}

/// Unit tests that test methods in the Ai Service
struct AiServiceTests {
    /// Ensure getRecipes can handle being passed an empty list of ingredients.
    @Test func testGetRecipes_emptyIngredients_returnsEmptyRecipes() async throws {
        let mockJSON = #"{}"#.data(using: .utf8)!
        let mockSession = MockNetworkSession(mockData: mockJSON)
        let aiService = AiService(session: mockSession)

        let recipes = await aiService.getRecipes(ingredients: [])
        
        #expect(recipes.isEmpty)
    }
    
    /// Ensure getRecipes just returns an empty list of recipes when the HTTP request to the LLM fails.
    @Test func testGetRecipes_networkRequestFailure_returnsEmptyRecipes() async throws {
        let mockJSON = #"{}"#.data(using: .utf8)!
        let mockSession = MockNetworkSession(mockData: mockJSON, shouldThrowError: true)
        let aiService = AiService(session: mockSession)

        let recipes = await aiService.getRecipes(ingredients: [])
        
        #expect(recipes.isEmpty)
    }
    
    /// Ensure getRecipes sucessfully returns one recipe for when the LLM returns one recipe in the JSON response.
    @Test func testGetRecipes_oneIngredient_returnsRecipes() async throws {
        let recipesResponse = #"""
        [
            {
                "name": "Boiled Egg",
                "estimatedTime": "1 minute",
                "ingredients": [],
                "instructions": []
            }
        ]
        """#
        
        
        let mockJSON = makeMockGeminiResponse(text: recipesResponse)
        let mockSession = MockNetworkSession(mockData: mockJSON)
        let aiService = AiService(session: mockSession)

        let recipes = await aiService.getRecipes(ingredients: [
            Ingredient(
                quantity: 1,
                quantityMassUnit: "",
                ingredientType: IngredientType(name: "Egg", icon: "", quantityUnit: QuantityUnit.count),
                storedIngredientID: nil
            )
        ])
        
        #expect(recipes.count == 1)
        #expect(recipes[0].name == "Boiled Egg")
        #expect(recipes[0].estimatedTime == "1 minute")
    }
    
    /// Ensure getRecipeStepClarification returns an error string rather than throwing an error when the HTTP request to the LLM fails.
    @Test func testGetRecipeStepClarification_networkRequestFailure_returnsErrorMessage() async throws {
        let mockJSON = #"{}"#.data(using: .utf8)!
        let mockSession = MockNetworkSession(mockData: mockJSON, shouldThrowError: true)
        let aiService = AiService(session: mockSession)

        let clarification = await aiService.getRecipeStepClarification(instruction:
            Instruction(
                instruction: "Test instruction",
                timer: 0,
            )
        )
        
        #expect(clarification == "Error")
    }
    
    /// Ensure getRecipeStepClarification returns the clarification response from the LLM as a string.
    @Test func testGetRecipeStepClarification_instruction_returnsClarification() async throws {
        let clarificationJSON = #"""
        {
            "clarification": "Step clarification 123",
        }
        """#
        
        let mockJSON = makeMockGeminiResponse(text: clarificationJSON)
        let mockSession = MockNetworkSession(mockData: mockJSON)
        let aiService = AiService(session: mockSession)

        let clarification = await aiService.getRecipeStepClarification(instruction:
            Instruction(
                instruction: "This is a test instruction",
                timer: 123,
            )
        )
        
        #expect(clarification == "Step clarification 123")
    }
}
