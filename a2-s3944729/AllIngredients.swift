//
//  AllIngredients.swift
//  assignment-1
//
//  Module that stores a list of ingredients the user can add.
//
//  Created by Jake Parkinson on 23/8/2025.
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

struct AllIngredients {
    static let ingredients = [
        // Fruits
        IngredientType(name: "Apple", icon: "fruit", quantityUnit: QuantityUnit.count),
        IngredientType(name: "Banana", icon: "fruit", quantityUnit: QuantityUnit.count),
        IngredientType(name: "Orange", icon: "fruit", quantityUnit: QuantityUnit.count),
        IngredientType(name: "Strawberry", icon: "fruit", quantityUnit: QuantityUnit.count),
        IngredientType(name: "Grapes", icon: "fruit", quantityUnit: QuantityUnit.weight),
        IngredientType(name: "Blueberry", icon: "fruit", quantityUnit: QuantityUnit.weight),

        // Vegetables
        IngredientType(name: "Carrot", icon: "vegetable", quantityUnit: QuantityUnit.count),
        IngredientType(name: "Broccoli", icon: "vegetable", quantityUnit: QuantityUnit.count),
        IngredientType(name: "Onion", icon: "vegetable", quantityUnit: QuantityUnit.count),
        IngredientType(name: "Tomato", icon: "vegetable", quantityUnit: QuantityUnit.count),
        IngredientType(name: "Spinach", icon: "vegetable", quantityUnit: QuantityUnit.weight),
        IngredientType(name: "Bell Pepper", icon: "vegetable", quantityUnit: QuantityUnit.count),
        IngredientType(name: "Cucumber", icon: "vegetable", quantityUnit: QuantityUnit.count),

        // Dairy
        IngredientType(name: "Egg", icon: "dairy", quantityUnit: QuantityUnit.count),
        IngredientType(name: "Cheese", icon: "dairy", quantityUnit: QuantityUnit.weight),
        IngredientType(name: "Butter", icon: "dairy", quantityUnit: QuantityUnit.weight),
        IngredientType(name: "Milk", icon: "dairy", quantityUnit: QuantityUnit.litres),
        IngredientType(name: "Yogurt", icon: "dairy", quantityUnit: QuantityUnit.weight),

        // Grains
        IngredientType(name: "Bread", icon: "grain", quantityUnit: QuantityUnit.count),
        IngredientType(name: "Rice", icon: "grain", quantityUnit: QuantityUnit.weight),
        IngredientType(name: "Pasta", icon: "grain", quantityUnit: QuantityUnit.weight),
        IngredientType(name: "Oats", icon: "grain", quantityUnit: QuantityUnit.weight),

        // Spices
        IngredientType(name: "Pepper", icon: "spice", quantityUnit: QuantityUnit.count),
        IngredientType(name: "Salt", icon: "spice", quantityUnit: QuantityUnit.weight),
        IngredientType(name: "Olive Oil", icon: "spice", quantityUnit: QuantityUnit.litres),
        IngredientType(name: "Garlic", icon: "spice", quantityUnit: QuantityUnit.weight),

        // Proteins
        IngredientType(name: "Chicken", icon: "protein", quantityUnit: QuantityUnit.weight),
        IngredientType(name: "Beef", icon: "protein", quantityUnit: QuantityUnit.weight),
        IngredientType(name: "Fish", icon: "protein", quantityUnit: QuantityUnit.count),
        IngredientType(name: "Tofu", icon: "protein", quantityUnit: QuantityUnit.weight),

        // Miscellaneous
        IngredientType(name: "White Chocolate", icon: "misc", quantityUnit: QuantityUnit.weight),
        IngredientType(name: "Milk Chocolate", icon: "misc", quantityUnit: QuantityUnit.weight),
        IngredientType(name: "Dark Chocolate", icon: "misc", quantityUnit: QuantityUnit.weight),
        IngredientType(name: "Honey", icon: "misc", quantityUnit: QuantityUnit.weight),
        IngredientType(name: "Lemon", icon: "misc", quantityUnit: QuantityUnit.count)
    ]
}
