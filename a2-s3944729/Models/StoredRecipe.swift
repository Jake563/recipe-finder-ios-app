//
//  StoredRecipe.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 11/10/2025.
//

import Foundation
import SwiftData

/// Represents a locally stored recipe
@Model final class StoredRecipe {
    var id = UUID()
    var recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
