//
//  IngredientsView.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 21/8/2025.
//

import SwiftUI
import SwiftData

/// View that list of all the user's saved ingredients.
struct IngredientsView: View {
    @State private var searchText: String = ""
    
    @Query
    private var storedIngredients: [StoredIngredient]
    
    private var filteredIngredients: [Ingredient] {
        let ingredients = IngredientService.storedIngredientsToIngredients(storedIngredients: storedIngredients)
        guard !searchText.isEmpty else {
            return ingredients
        }
        return ingredients.filter {
            $0.ingredientType.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    VStack {
                        HStack {
                            Spacer()
                            Text("Quantity")
                                .offset(x: -30)
                        }
                        List(filteredIngredients) { ingredient in
                            NavigationLink(destination: IngredientDetailsView(ingredient: ingredient, addingIngredient: false)) {
                                HStack {
                                    Image(ingredient.ingredientType.icon)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                    Text(ingredient.ingredientType.name.capitalized)
                                    Spacer()
                                    if let quantityMassUnit = ingredient.quantityMassUnit {
                                        Text("\(ingredient.quantity)\(quantityMassUnit)")
                                    } else {
                                        Text("\(ingredient.quantity)")
                                    }
                                }
                            }
                            .listRowBackground(PRIMARY_BUTTON_COLOUR)
                        }
                        .listRowSpacing(20)
                        .searchable(text: $searchText, prompt: "Search for an ingredient")
                        .scrollContentBackground(.hidden)
                    }
                    if storedIngredients.isEmpty {
                        Text("You currently have no ingredients.")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Ingredients")
                        .font(.title)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NewIngredientView()) {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(SquareButtonStyle())
                }
            }
        }
    }
}

#Preview {
    IngredientsView()
}
