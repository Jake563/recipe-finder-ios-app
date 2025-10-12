//
//  IngredientService.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 18/9/2025.
//

import SwiftData

/// A helper service that provides common methods related to ingredients.
class IngredientService {
    private let context: ModelContext
    private let ingredientTypeService = IngredientTypeService()
    
    init(context: ModelContext) {
        self.context = context
    }
    
    static func storedIngredientsToIngredients(storedIngredients: [StoredIngredient]) -> [Ingredient] {
        var ingredients: [Ingredient] = []
        for storedIngredient in storedIngredients {
            ingredients.append(Ingredient(
                quantity: storedIngredient.quantity,
                quantityMassUnit: storedIngredient.quantityMassUnit,
                ingredientType: IngredientTypeService.getIngredientByName(ingredientName: storedIngredient.ingredientTypeName)!,
                storedIngredientID: storedIngredient.id
            ))
        }
        return ingredients
    }
    
    func getIngredient(name: String) throws -> StoredIngredient? {
        let ingredients = try context.fetch(FetchDescriptor<StoredIngredient>())
        for ingredient in ingredients {
            if ingredient.ingredientTypeName == name {
                return ingredient
            }
        }
        return nil
    }
    
    private func updateIngredientQuantity(ingredient: StoredIngredient, quantity: Int, unit: String?) {
        if ingredient.quantityMassUnit == unit {
            ingredient.quantity += quantity
            return
        }
        if ingredient.quantityMassUnit == nil {
            ingredient.quantity += quantity
            return
        }
        if unit == nil {
            ingredient.quantity += quantity
            return
        }

        var baseQuantity = ingredient.quantity
        var addedQuantity = quantity
        var finalUnit = ingredient.quantityMassUnit!

        switch (ingredient.quantityMassUnit!.lowercased(), unit!.lowercased()) {
        case ("l", "ml"):
            // Convert ingredient to mL
            baseQuantity *= 1000
            finalUnit = "mL"
        case ("ml", "l"):
            // Convert added to mL
            addedQuantity *= 1000
        case ("kg", "g"):
            baseQuantity *= 1000
            finalUnit = "g"
        case ("g", "kg"):
            addedQuantity *= 1000
        case let (u1, u2) where u1 == u2:
            break
        default:
            print("Unsupported unit conversion from \(unit!) to \(ingredient.quantityMassUnit!)")
            return
        }

        ingredient.quantity = baseQuantity + addedQuantity
        ingredient.quantityMassUnit = finalUnit
    }
    
    func addIngredient(name: String, quantity: Int, unit: String?) throws {
        let existingIngredient = try getIngredient(name: name)
        if existingIngredient != nil {
            updateIngredientQuantity(ingredient: existingIngredient!, quantity: quantity, unit: unit)
            return
        }
        
        let foundIngredientType = IngredientTypeService.getIngredientByName(ingredientName: name)
        if foundIngredientType == nil {
            return
        }
        
        let newIngredient = StoredIngredient(
            quantity: quantity,
            quantityMassUnit: unit,
            ingredientTypeName: foundIngredientType!.name
        )
        
        context.insert(newIngredient)
        try context.save()
    }
    
    func deleteIngredient(name: String) throws {
        let ingredientToDelete = try getIngredient(name: name)
        
        if ingredientToDelete == nil {
            return
        }

        context.delete(ingredientToDelete!)
        try context.save()
    }
    
    func updateIngredient(name: String, quantityDiff: Int, unit: String?) throws {
        let ingredientToUpdate = try getIngredient(name: name)

        if ingredientToUpdate == nil {
            return
        }
        
        updateIngredientQuantity(ingredient: ingredientToUpdate!, quantity: quantityDiff, unit: unit)
        if ingredientToUpdate!.quantity <= 0 {
            context.delete(ingredientToUpdate!)
        }
        try context.save()
    }
}
