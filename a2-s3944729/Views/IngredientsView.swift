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
    @State private var filteredIngredients: [Ingredient] = []
    @EnvironmentObject var ingredientStore: IngredientStore
    
    @Query
    private var storedIngredients: [StoredIngredient]
    
    private func searchIngredients() {
        let ingredients = IngredientService.storedIngredientsToIngredients(storedIngredients: storedIngredients)
        
        if searchText.isEmpty {
            filteredIngredients = ingredients
            return
        }
        var filteredIngredients: [Ingredient] = []
        for ingredient in ingredients {
            if ingredient.ingredientType.name.lowercased().contains(searchText.lowercased()) {
                filteredIngredients.append(ingredient)
            }
        }
        self.filteredIngredients = filteredIngredients
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
                                    Text(ingredient.ingredientType.name)
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
                        .onChange(of: searchText) {
                            searchIngredients()
                        }
                        .scrollContentBackground(.hidden)
                    }
                    if storedIngredients.isEmpty {
                        Text("You currently have no ingredients.")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onAppear() {
                searchIngredients()
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
        .environmentObject(IngredientStore())
}
