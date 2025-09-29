//
//  SavedRecipe.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 20/9/2025.
//

import Foundation
import FirebaseFirestore

/// Represents a recipe a user has saved to their favourites.
struct SavedRecipe: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var priority: Int
    var recipe: Recipe
}
