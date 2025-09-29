//
//  SavedRecipesView.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 21/8/2025.
//

import SwiftUI

/// View that lists all the recipes a user has favourited.
struct SavedRecipesView: View {
    @State private var savedRecipes: [SavedRecipe] = []
    @State private var recipeBeingDraggedID: String?
    @State private var recipeBeingLongedPressedID: String?
    @State private var buttonOffset = 0.0
    @State private var pressedButtonIndex: Int? = nil
    
    private func isPressedRecipeAboveFunc(recipeIndex: Int) -> Bool {
        if pressedButtonIndex == nil {
            return false
        }
        
        if pressedButtonIndex == recipeIndex {
            return false
        }
        
        if recipeIndex > pressedButtonIndex! {
            return false
        }
        
        let yThreshold = (recipeIndex - pressedButtonIndex!) * (100)
        let isAbove = Int(buttonOffset) < yThreshold
        
        return isAbove
    }
    
    private func isPressedRecipeBelowFunc(recipeIndex: Int) -> Bool {
        if pressedButtonIndex == nil {
            return false
        }
        
        if pressedButtonIndex == recipeIndex {
            return false
        }
        
        if recipeIndex < pressedButtonIndex! {
            return false
        }
        
        let yThreshold = (recipeIndex - pressedButtonIndex!) * (100)
        let isBelow = Int(buttonOffset) > yThreshold
        
        return isBelow
    }
    
    private func getButtonOffset(isAbove: Bool, isBelow: Bool, recipeIsPressed: Bool) -> CGFloat {
        if recipeIsPressed {
            return buttonOffset
        }
        if isAbove {
            return 100
        }
        if isBelow {
            return -100
        }
        return 0
    }
    
    private func loadSavedRecipes() {
        Task {
            //let recipes = try? await SavedRecipesService.getRecipes()
            //savedRecipes = recipes ?? []
            
            // Create dummy recipes
            savedRecipes = [
                SavedRecipe(
                    id: "a",
                    userId: "abc",
                    recipe: Recipe(
                        name: "Test Recipe",
                        estimatedTime: "40 minutes",
                        ingredients: [],
                        instructions: []
                    )
                ),
                SavedRecipe(
                    id: "b",
                    userId: "abc",
                    recipe: Recipe(
                        name: "Test Recipe 2",
                        estimatedTime: "40 minutes",
                        ingredients: [],
                        instructions: []
                    )
                ),
                SavedRecipe(
                    id: "c",
                    userId: "abc",
                    recipe: Recipe(
                        name: "Test Recipe 3",
                        estimatedTime: "40 minutes",
                        ingredients: [],
                        instructions: []
                    )
                ),
                SavedRecipe(
                    id: "d",
                    userId: "abc",
                    recipe: Recipe(
                        name: "Test Recipe 4",
                        estimatedTime: "40 minutes",
                        ingredients: [],
                        instructions: []
                    )
                ),
            ]
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(Array(savedRecipes.enumerated()), id: \.element.id) { index, savedRecipe in
                                let dragGesture = DragGesture()
                                    .onChanged{value in
                                        print("Translation: \(value.translation.height)")
                                        buttonOffset = value.translation.height
                                        recipeBeingDraggedID = savedRecipe.id
                                        pressedButtonIndex = index
                                    }
                                    .onEnded { value in
                                        print("ENDED")
                                    }
                                let longPressGesture = LongPressGesture()
                                    .onChanged { value in
                                        print("long press changed")
                                    }
                                    .onEnded{ value in
                                        print("LONG PRESS ENDED")
                                        recipeBeingLongedPressedID = savedRecipe.id
                                    }
                                let combinedGesture = longPressGesture.sequenced(before: dragGesture)

                                let recipeIsDragged = recipeBeingDraggedID == savedRecipe.id
                                let recipeIsLongPressed = recipeBeingLongedPressedID == savedRecipe.id
                                
                                let isPressedRecipeAbove = isPressedRecipeAboveFunc(recipeIndex: index)
                                let isPressedRecipeBelow = isPressedRecipeBelowFunc(recipeIndex: index)
                                
                                let btnOffset = getButtonOffset(isAbove: isPressedRecipeAbove, isBelow: isPressedRecipeBelow, recipeIsPressed: recipeIsLongPressed)
                                
                                HStack {
                                    NavigationLink(destination: RecipeInfoView(recipe: savedRecipe.recipe)) {
                                        HStack {
                                            Text(savedRecipe.recipe.name)
                                        }
                                        Spacer()
                                    }
                                    .accentColor(.primary)
                                    Button(action: {
                                        try? SavedRecipesService.deleteRecipe(savedRecipeId: savedRecipe.id!)
                                        loadSavedRecipes()
                                    }) {
                                        Image(systemName: "heart.fill")
                                            .foregroundStyle(.pink)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .frame(height: 50)
                                .padding(16)
                                .background(Color(red:0.95, green:0.95, blue:0.95))
                                .cornerRadius(16)
                                .scaleEffect(recipeIsLongPressed ? 1.1 : 1)
                                .animation(.spring(), value: recipeBeingLongedPressedID)
                                .offset(y: btnOffset)
                                .gesture(combinedGesture)
                            }
                        }
                        .padding()
                    }
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
