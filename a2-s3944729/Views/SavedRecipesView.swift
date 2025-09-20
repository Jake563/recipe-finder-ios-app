//
//  SavedRecipesView.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 21/8/2025.
//

import SwiftUI

struct SavedRecipesView: View {
    @State private var savedRecipes: [SavedRecipe] = []
    
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
                                print("delete recipe not implemented")
                            }) {
                                Image(systemName: "heart")
                                    .foregroundStyle(.black)
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
                Task {
                    let recipes = try? await SavedRecipesService.getRecipes()
                    savedRecipes = recipes ?? []
                }
            }
        }
    }
}

#Preview {
    SavedRecipesView()
}
