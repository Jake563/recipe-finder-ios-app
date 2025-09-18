//
//  StoredIngredient.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 17/9/2025.
//

import Foundation
import SwiftData

@Model final class StoredIngredient {
    var quantity: Int
    var quantityMassUnit: String?
    var ingredientTypeID: Int
    
    init(quantity: Int, quantityMassUnit: String? = nil, ingredientTypeID: Int) {
        self.quantity = quantity
        self.quantityMassUnit = quantityMassUnit
        self.ingredientTypeID = ingredientTypeID
    }
}
