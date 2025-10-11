//
//  StoredIngredient.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 17/9/2025.
//

import Foundation
import SwiftData

/// Represents an ingredient a user has added to their ingredients list.
@Model final class StoredIngredient {
    var id = UUID()
    var quantity: Int
    var quantityMassUnit: String?
    var ingredientTypeName: String
    
    init(quantity: Int, quantityMassUnit: String? = nil, ingredientTypeName: String) {
        self.quantity = quantity
        self.quantityMassUnit = quantityMassUnit
        self.ingredientTypeName = ingredientTypeName
    }
}
