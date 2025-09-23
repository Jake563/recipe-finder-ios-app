//
//  NewIngredientView.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 22/8/2025.
//

import SwiftUI

/// View that allows a new ingredient to be added to a user's saved ingredients.
struct NewIngredientView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var ingredientStore: IngredientStore
    @State private var searchText: String = ""
    @State private var notificationVisible = false
    @State private var filteredIngredients: [IngredientType] = []
    private let MAX_SEARCH_RESULTS: Int = 10
    
    /// Displays ingredients that matches what the user has entered in the search field
    private func searchIngredients() {
        var searchResultCount = 0
        var ingredientRecognised = false
        
        if searchText.isEmpty {
            filteredIngredients.removeAll()
            return
        }
        
        var ingredients: Array<IngredientType> = []
        for ingredient in AllIngredients.ingredients {
            if ingredient.name.lowercased().contains(searchText.lowercased()) {
                ingredients.append(ingredient)
                searchResultCount += 1
                if searchResultCount == MAX_SEARCH_RESULTS {
                    break
                }
            }
            if ingredient.name == searchText {
                ingredientRecognised = true
            }
        }
        if !ingredientRecognised {
            ingredients.insert(IngredientType(name: searchText, icon: "misc", quantityUnit: QuantityUnit.count), at: 0)
        }
        filteredIngredients = ingredients
    }
    
    /// Displays a notification confirming that an ingredient has been added
    private func displayIngredientAddedNotification() {
        let twoSeconds: UInt64 = 2_000_000_000
        notificationVisible = true
        Task {
            try? await Task.sleep(nanoseconds: twoSeconds)
            notificationVisible = false
        }
    }
    
    /// Clears the text entered in the search field
    private func clearSearchText() {
        searchText = ""
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List(filteredIngredients) { ingredient in
                    NavigationLink(destination: IngredientDetailsView(
                        ingredient: Ingredient(
                            quantity: 1,
                            quantityMassUnit: nil,
                            ingredientType: ingredient,
                            storedIngredientID: nil // Ingredient is not stored yet
                        ),
                        addingIngredient: true)) {
                        Label(ingredient.name, systemImage: "plus")
                            .foregroundStyle(.black)
                    }
                    .listRowBackground(PRIMARY_BUTTON_COLOUR)
                }
                .searchable(text: $searchText, prompt: "Search for an ingredient")
                .onChange(of: searchText) {
                    searchIngredients()
                }
                .scrollContentBackground(.hidden)
                .listRowSpacing(20)
                if notificationVisible {
                    Text("Ingredient added!")
                        .foregroundStyle(.green)
                        .padding()
                        .font(.title)
                }
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
                    Text("New Ingredient")
                        .font(.title)
                }
            }
        }
        .onAppear() {
            if !ingredientStore.newIngredientAdded {
                return
            }
            clearSearchText()
            ingredientStore.newIngredientAdded = false
            displayIngredientAddedNotification()
        }
    }
}

#Preview {
    NewIngredientView()
        .environmentObject(IngredientStore())
}
