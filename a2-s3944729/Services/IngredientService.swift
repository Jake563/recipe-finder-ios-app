//
//  IngredientService.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 18/9/2025.
//

class IngredientService {
    static func storedIngredientsToIngredients(storedIngredients: [StoredIngredient]) -> [Ingredient] {
        var ingredients: [Ingredient] = []
        for storedIngredient in storedIngredients {
            ingredients.append(Ingredient(
                quantity: storedIngredient.quantity,
                quantityMassUnit: storedIngredient.quantityMassUnit,
                ingredientType: AllIngredients.ingredients[storedIngredient.ingredientTypeID]
            ))
        }
        return ingredients
    }
}
