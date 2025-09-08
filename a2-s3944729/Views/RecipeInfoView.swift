//
//  RecipeInfoView.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 24/8/2025.
//

import SwiftUI

struct RecipeInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var ingredientStore: IngredientStore
    
    let recipe: Recipe
    
    private func getCorrespondingIngredient(requiredIngredient: RequiredIngredient) -> Ingredient? {
        for ingredient in ingredientStore.ingredients {
            if ingredient.ingredientType.name == requiredIngredient.name {
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
                                Text(requiredIngredient.name)
                            }
                            Spacer()
                            Text("\(String(requiredIngredient.quantity))\(requiredIngredient.quantityMassUnit ?? "")")
                        }
                        Divider()
                    }
                }
                .listRowSpacing(5)
                .scrollContentBackground(.hidden)
                Button(action: {
                    print("View instructions")
                }) {
                    Text("View Instructions")
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
                            .foregroundColor(.black)
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
        instructions: []
    )).environmentObject(IngredientStore())
}
