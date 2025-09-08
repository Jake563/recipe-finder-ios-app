//
//  Recipe.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 8/9/2025.
//

import Foundation

struct Recipe: Codable, Identifiable {
    let id = UUID()
    let name: String
    let ingredients: [RequiredIngredient]
    let instructions: [String]
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case ingredients = "ingredients"
        case instructions = "instructions"
    }
}
