//
//  Ingredient.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 8/9/2025.
//

import Foundation

struct Ingredient: Identifiable {
    let id: UUID = UUID()
    let name: String
    let quantity: Int
    let quantityMassUnit: String?
    let ingredientType: IngredientType?
}
