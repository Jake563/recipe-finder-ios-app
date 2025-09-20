//
//  Recipe.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 8/9/2025.
//

import Foundation
import FirebaseFirestore

struct Recipe: Identifiable, Codable {
    let id = UUID()
    let name: String
    let estimatedTime: String
    let ingredients: [RequiredIngredient]
    let instructions: [Instruction]
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case estimatedTime = "estimatedTime"
        case ingredients = "ingredients"
        case instructions = "instructions"
    }
}
