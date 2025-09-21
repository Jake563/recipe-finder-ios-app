//
//  AiServiceTests.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 20/9/2025.
//

import Testing
@testable import a2_s3944729
import Foundation

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

struct AiServiceTests {
    func beforeEach() {
        
    }

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test func testGetRecipes_emptyIngredients_returnsEmptyRecipes() async throws {
        let mockJSON = #"{}"#.data(using: .utf8)!
        let mockSession = MockNetworkSession(mockData: mockJSON)
        let aiService = AiService(session: mockSession)

        let recipes = await aiService.getRecipes(ingredients: [])
        
        #expect(recipes.isEmpty)
    }
    
    @Test func testGetRecipes_networkRequestFailure_returnsEmptyRecipes() async throws {
        let mockJSON = #"{}"#.data(using: .utf8)!
        let mockSession = MockNetworkSession(mockData: mockJSON, shouldThrowError: true)
        let aiService = AiService(session: mockSession)

        let recipes = await aiService.getRecipes(ingredients: [])
        
        #expect(recipes.isEmpty)
    }

}
