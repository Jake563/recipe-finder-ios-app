//
//  SavedRecipesView.swift
//  a2-s3944729
//
//  View that lists all the recipes a user has favourited.
//
//  Created by Jake Parkinson on 21/8/2025.
//

import SwiftUI

struct SavedRecipesView: View {
    @State private var savedRecipes: [SavedRecipe] = []
    
    private func loadSavedRecipes() {
        Task {
            let recipes = try? await SavedRecipesService.getRecipes()
            savedRecipes = recipes ?? []
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    List(savedRecipes) { savedRecipe in
                        HStack {
                            NavigationLink(destination: RecipeInfoView(recipe: savedRecipe.recipe)) {
                                HStack {
                                    Text(savedRecipe.recipe.name)
                                }
                            }
                            Button(action: {
                                try? SavedRecipesService.deleteRecipe(savedRecipeId: savedRecipe.id!)
                                loadSavedRecipes()
                            }) {
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(.pink)
                            }
                            .buttonStyle(.plain)
                        }
                        .listRowBackground(PRIMARY_BUTTON_COLOUR)
                        .frame(height: 50)
                    }
                    .listRowSpacing(20)
                    .scrollContentBackground(.hidden)
                    if savedRecipes.isEmpty {
                        Text("You have no saved recipes.")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Saved Recipes")
                        .font(.title)
                }
            }
            .onAppear {
                loadSavedRecipes()
            }
        }
    }
}

#Preview {
    SavedRecipesView()
}
