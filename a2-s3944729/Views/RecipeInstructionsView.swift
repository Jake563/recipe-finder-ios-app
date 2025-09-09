//
//  RecipeInstructionsView.swift
//  a2-s3944729
//
//  View that contains all the steps for a recipe, only showing one step at a time.
//
//  Created by Jake Parkinson on 9/9/2025.
//

import SwiftUI

struct RecipeInstructionsView: View {
    let recipe: Recipe
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    RecipeInstructionsView(recipe: Recipe(
        name: "Test Recipe",
        estimatedTime: "40 minutes",
        ingredients: [
            RequiredIngredient(name: "Egg", quantity: 50, quantityMassUnit: nil),
            RequiredIngredient(name: "Milk", quantity: 20, quantityMassUnit: "mL")
        ],
        instructions: []
    ))
}
