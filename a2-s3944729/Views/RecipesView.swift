//
//  RecipesView.swift
//  a2-s3944729
//
//  View that displays a list of recipes a user can make with their ingredients.
//
//  Created by Jake Parkinson on 21/8/2025.
//

import SwiftUI
import SwiftData

struct RecipesView: View {
    @State private var recipesLoading = false
    @State private var recipes: [Recipe] = []
    @State private var favouritedRecipes = [String: String]()
    @EnvironmentObject private var ingredientStore: IngredientStore
    
    @Query
    private var storedIngredients: [StoredIngredient]
    
    /// Displays a list of recipes that can be made with the user's current ingredients
    private func onViewOpened() {
        if recipesLoading {
            return
        }
        if !ingredientStore.hasIngredientChanged {
            // User has not made any changes to their ingredients since the last time recipes were displayed
            recipesLoading = false
            return
        }
        recipesLoading = true
        ingredientStore.hasIngredientChanged = false
        recipes.removeAll()
        Task {
            let ingredients = IngredientService.storedIngredientsToIngredients(storedIngredients: storedIngredients)
            recipes = await AiService.getRecipes(ingredients: ingredients)
            recipesLoading = false
        }
    }
    
    /// Returns what placeholder text should be displayed on the screen
    private func getStatusTextView() -> AnyView {
        if storedIngredients.isEmpty {
            return AnyView(Text("Add ingredients to see a list of recipes!")
                .foregroundStyle(.secondary))
        }
        if recipesLoading {
            return AnyView(ProgressView("Finding recipes..."))
        }
        if recipes.isEmpty {
            return AnyView(Text("No recipes available for your current ingredients.")
                .foregroundStyle(.secondary))
        }
        return AnyView(Text(""))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    List(recipes) { recipe in
                        HStack {
                            NavigationLink(destination: RecipeInfoView(recipe: recipe)) {
                                HStack {
                                    Text(recipe.name)
                                }
                            }
                            Button(action: {
                                let savedRecipeId = favouritedRecipes[recipe.id.uuidString]
                                
                                if savedRecipeId != nil {
                                    try? SavedRecipesService.deleteRecipe(savedRecipeId: savedRecipeId!)
                                    favouritedRecipes.removeValue(forKey: recipe.id.uuidString)
                                } else {
                                    do {
                                        let savedRecipeId = try SavedRecipesService.addRecipe(recipe: recipe)
                                        favouritedRecipes[recipe.id.uuidString] = savedRecipeId
                                    } catch {
                                        print("Failed to save recipe: \(error)")
                                    }
                                }
                            }) {
                                if favouritedRecipes[recipe.id.uuidString] != nil {
                                    Image(systemName: "heart.fill")
                                        .foregroundStyle(.pink)
                                } else {
                                    Image(systemName: "heart")
                                        .foregroundStyle(.black)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .listRowBackground(PRIMARY_BUTTON_COLOUR)
                        .frame(height: 50)
                    }
                    .listRowSpacing(20)
                    .scrollContentBackground(.hidden)
                    getStatusTextView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Recipes")
                        .font(.title)
                }
            }
            .onAppear {
                onViewOpened()
            }
        }
    }
}

#Preview {
    RecipesView()
        .environmentObject(IngredientStore())
}
