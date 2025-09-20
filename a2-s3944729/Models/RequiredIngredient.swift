//
//  RequiredIngredient.swift
//  a2-s3944729
//
//  Represents an ingredient required for a recipe.
//
//  Created by Jake Parkinson on 8/9/2025.
//

import Foundation

struct RequiredIngredient: Identifiable, Codable {
    let id = UUID()
    let name: String
    let quantity: Int
    let quantityMassUnit: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case quantity = "quantity"
        case quantityMassUnit = "quantityMassUnit"
    }
}
