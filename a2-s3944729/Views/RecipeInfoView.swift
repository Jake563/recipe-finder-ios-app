//
//  RecipeInfoView.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 24/8/2025.
//

import SwiftUI
import SwiftData

/// View that displays the basic information of a recipe, including the estimated time and required ingredients.
struct RecipeInfoView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Query
    private var storedIngredients: [StoredIngredient]
    
    let recipe: Recipe
    
    private func getCorrespondingIngredient(requiredIngredient: RequiredIngredient) -> Ingredient? {
        let ingredients = IngredientService.storedIngredientsToIngredients(storedIngredients: storedIngredients)
        
        for ingredient in ingredients {
            if ingredient.ingredientType.name == requiredIngredient.name.lowercased() {
                return ingredient
            }
        }
        return nil
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "clock")
                    Text(recipe.estimatedTime)
                        .font(.title2)
                    Spacer()
                }
                .padding(.horizontal)
                Spacer(minLength: 30)
                HStack {
                    Text("Ingredients")
                        .font(.title2)
                    Spacer()
                }
                .padding(.horizontal)
                List(recipe.ingredients) { requiredIngredient in
                    let correspondingIngredient = getCorrespondingIngredient(requiredIngredient: requiredIngredient)
                    VStack {
                        HStack {
                            HStack {
                                if correspondingIngredient != nil {
                                    Image(correspondingIngredient!.ingredientType.icon)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                }
                                Text(requiredIngredient.name.capitalized)
                            }
                            Spacer()
                            Text("\(String(requiredIngredient.quantity))\(requiredIngredient.quantityMassUnit ?? "")")
                        }
                        Divider()
                    }
                }
                .listRowSpacing(5)
                .scrollContentBackground(.hidden)

                NavigationLink(destination: RecipeInstructionsView(recipe: recipe)) {
                    Text("View instructions")
                        .frame(maxWidth: .infinity)
                        .font(.title)
                }
                .padding()
                .buttonStyle(PrimaryButtonStyle())
            }

            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.primary)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(recipe.name)
                        .font(.title)
                }
            }
        }
    }
}

#Preview {
    RecipeInfoView(recipe: Recipe(
        name: "Test Recipe",
        estimatedTime: "40 minutes",
        ingredients: [
            RequiredIngredient(name: "Egg", quantity: 50, quantityMassUnit: nil),
            RequiredIngredient(name: "Milk", quantity: 20, quantityMassUnit: "mL")
        ],
        instructions: [
            Instruction(instruction: "Preheat stove top for 10 minutes.", timer: 5),
            Instruction(instruction: "Crack eggs into pan.", timer: 0)
        ]
    ))
}
