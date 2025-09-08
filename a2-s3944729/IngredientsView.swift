//
//  IngredientsView.swift
//  assignment-1
//
//  View that list of all the user's saved ingredients.
//
//  Created by Jake Parkinson on 21/8/2025.
//

import SwiftUI

struct Ingredient: Identifiable {
    let id: UUID = UUID()
    let name: String
    let quantity: Int
    let quantityMassUnit: String?
    let ingredientType: IngredientType?
}

struct IngredientsView: View {
    @State private var searchText: String = ""
    @State private var filteredIngredients: [Ingredient] = []
    @EnvironmentObject var ingredientStore: IngredientStore
    
    private func searchIngredients() {
        if searchText.isEmpty {
            filteredIngredients = ingredientStore.ingredients
            return
        }
        var ingredients: [Ingredient] = []
        for ingredient in ingredientStore.ingredients {
            if ingredient.name.lowercased().contains(searchText.lowercased()) {
                ingredients.append(ingredient)
            }
        }
        filteredIngredients = ingredients
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
                                    Image(ingredient.ingredientType?.icon ?? "misc")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                    Text(ingredient.name)
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
                    if ingredientStore.ingredients.isEmpty {
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
