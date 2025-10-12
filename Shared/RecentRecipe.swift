//
//  RecentRecipe.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 8/9/2025.
//

import Foundation
import SwiftData

/// A recipe that has been recently generated
@Model final class RecentRecipe {
    var id = UUID()
    var name: String
    var estimatedTime: String
    var ingredients: [RequiredIngredient]
    var instructions: [Instruction]
    
    init(id: UUID = UUID(), name: String, estimatedTime: String, ingredients: [RequiredIngredient], instructions: [Instruction]) {
        self.id = id
        self.name = name
        self.estimatedTime = estimatedTime
        self.ingredients = ingredients
        self.instructions = instructions
    }
}
