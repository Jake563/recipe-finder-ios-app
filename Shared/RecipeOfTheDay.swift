//
//  Recipe.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 8/9/2025.
//

import Foundation
import SwiftData

/// Represents a dish a user can make.
@Model final class RecipeOfTheDay {
    var id = UUID()
    var name: String
    var estimatedTime: String
    var numberOfIngredients: Int
    
    init(id: UUID = UUID(), name: String, estimatedTime: String, numberOfIngredients: Int) {
        self.id = id
        self.name = name
        self.estimatedTime = estimatedTime
        self.numberOfIngredients = numberOfIngredients
    }
}
