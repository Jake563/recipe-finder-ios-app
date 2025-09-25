//
//  IngredientType.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 8/9/2025.
//

import Foundation

enum QuantityUnit: String, Codable {
    case count, weight, litres
}

///  Represents an ingredient a user can add.
struct IngredientType: Identifiable {
    let id: UUID = UUID()
    let name: String
    let icon: String
    let quantityUnit: QuantityUnit
}
