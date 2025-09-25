//
//  AllIngredients.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 23/8/2025.
//

import Foundation

// Temporary struct just for decoding JSON (no id)
private struct IngredientDTO: Codable {
    let name: String
    let icon: String
    let quantityUnit: QuantityUnit
}

/// Module that stores a list of ingredients the user can add.
struct AllIngredients {
    private static let FILE_NAME = "IngredientTypes"
    static let ingredients = getIngredientsFromFile()
    
    /// Returns a list of ingredient types stored in the Ingredient types JSON file
    static private func getIngredientsFromFile() -> [IngredientType] {
        guard let url = Bundle.main.url(forResource: FILE_NAME, withExtension: "json") else {
            print("Could not find \(FILE_NAME).json")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decoded = try decoder.decode([IngredientDTO].self, from: data)
            
            // Map DTOs into real IngredientType (with new UUIDs)
            return decoded.map {
                IngredientType(name: $0.name, icon: $0.icon, quantityUnit: $0.quantityUnit)
            }
        } catch {
            print("Failed to decode \(FILE_NAME).json: \(error)")
            return []
        }
    }

}
