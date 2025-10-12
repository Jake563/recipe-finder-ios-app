//
//  IngredientService.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 18/9/2025.
//

/// A helper service that provides common methods related to ingredients.
class IngredientService {
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
}
