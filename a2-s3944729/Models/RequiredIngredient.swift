//
//  RequiredIngredient.swift
//  a2-s3944729
//
//  Represents an ingredient required for a recipe.
//
//  Created by Jake Parkinson on 8/9/2025.
//

import Foundation

struct RequiredIngredient: Codable, Identifiable {
    let id: UUID = UUID()
    let name: String
    let quantity: Int
    let quantityMassUnit: String?
}
