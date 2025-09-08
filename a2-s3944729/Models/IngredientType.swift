//
//  IngredientType.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 8/9/2025.
//

import Foundation

enum QuantityUnit {
    case count, weight, litres
}

struct IngredientType: Identifiable {
    let id: UUID = UUID()
    let name: String
    let icon: String
    let quantityUnit: QuantityUnit
}
