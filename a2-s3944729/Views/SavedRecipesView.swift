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
    
    private let BUTTON_HEIGHT: CGFloat = 50
    
    /// Returns true if the recipe the user is dragging is above the recipe button of the given index.
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
        
        let yThreshold = (recipeIndex - pressedButtonIndex!) * (Int(BUTTON_HEIGHT) * 2)
        let isAbove = Int(buttonOffset) < yThreshold
        
        return isAbove
    }
    
    /// Returns true if the recipe the user is dragging is below the recipe button of the given index.
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
        
        let yThreshold = (recipeIndex - pressedButtonIndex!) * (Int(BUTTON_HEIGHT) * 2)
        let isBelow = Int(buttonOffset) > yThreshold
        
        return isBelow
    }
    
    /// Returns what the offset a button should be.
    private func getButtonOffset(isAbove: Bool, isBelow: Bool, recipeIsPressed: Bool) -> CGFloat {
        if recipeIsPressed {
            return buttonOffset
        }
        if isAbove {
            return BUTTON_HEIGHT * 2
        }
        if isBelow {
            return BUTTON_HEIGHT * -2
        }
        return 0
    }
    
    /// Returns the index change for the given offset.
    private func offsetToIndexChange(offset: Double) -> Int {
        return Int(offset / 100)
    }
    
    /// Updates the priority of the recipe based on the position its button was dragged to.
    private func updatePressedRecipePriority() {
        if pressedButtonIndex == nil {
            return
        }

        print("Current Index: \(pressedButtonIndex!)")
        print("Offset: \(buttonOffset)")
        let indexChange = offsetToIndexChange(offset: buttonOffset)
        let newIndex = pressedButtonIndex! + indexChange
        print("New Index: \(newIndex)")
        
        if newIndex < 0 {
            return
        }
        if newIndex >= savedRecipes.count {
            return
        }

        let recipe = savedRecipes[pressedButtonIndex!]
        savedRecipes.remove(at: pressedButtonIndex!)
        savedRecipes.insert(recipe, at: newIndex)

        var recipesToUpdate: [(String, Int)] = []
        
        if newIndex <= pressedButtonIndex! {
            for newPriority in newIndex...pressedButtonIndex! {
                let recipeAtIndex = savedRecipes[newPriority]
                recipesToUpdate.append((recipeAtIndex.id!, newPriority))
            }
        } else {
            for newPriority in pressedButtonIndex!...newIndex {
                let recipeAtIndex = savedRecipes[newPriority]
                recipesToUpdate.append((recipeAtIndex.id!, newPriority))
            }
        }
        
        do {
            try SavedRecipesService.changeRecipeOrder(recipesToUpdate: recipesToUpdate)
        } catch {
            print("Failed to change recipe order: \(error)")
        }
    }
    
    /// Displays the user's saved recipes from the database
    private func loadSavedRecipes() {
        Task {
            do {
                let recipes = try await SavedRecipesService.getRecipes()
                savedRecipes = recipes
            } catch {
                print("Failed to get saved recipes: \(error)")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(Array(savedRecipes.enumerated()), id: \.element.id) { index, savedRecipe in
                                let dragGesture = DragGesture(minimumDistance: 0)
                                    .onChanged{value in
                                        buttonOffset = value.translation.height
                                        recipeBeingDraggedID = savedRecipe.id
                                        pressedButtonIndex = index
                                    }
                                    .onEnded { value in
                                        updatePressedRecipePriority()
                                        recipeBeingDraggedID = nil
                                        recipeBeingLongedPressedID = nil
                                        pressedButtonIndex = nil
                                        buttonOffset = 0
                                    }
                                let longPressGesture = LongPressGesture()
                                    .onEnded{ value in
                                        recipeBeingLongedPressedID = savedRecipe.id
                                    }
                                let combinedGesture = longPressGesture.sequenced(before: dragGesture)

                                let recipeIsLongPressed = recipeBeingLongedPressedID == savedRecipe.id
                                
                                let isPressedRecipeAbove = isPressedRecipeAboveFunc(recipeIndex: index)
                                let isPressedRecipeBelow = isPressedRecipeBelowFunc(recipeIndex: index)
                                
                                let offset = getButtonOffset(isAbove: isPressedRecipeAbove, isBelow: isPressedRecipeBelow, recipeIsPressed: recipeIsLongPressed)
                                
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
                                .frame(height: BUTTON_HEIGHT)
                                .padding(16)
                                .background(Color(red:0.95, green:0.95, blue:0.95))
                                .cornerRadius(16)
                                .scaleEffect(recipeIsLongPressed ? 1.1 : 1)
                                .animation(.spring(), value: recipeBeingLongedPressedID)
                                .offset(y: offset)
                                .animation(.spring(), value: isPressedRecipeAbove)
                                .animation(.spring(), value: isPressedRecipeBelow)
                                .gesture(combinedGesture)
                                .zIndex(recipeIsLongPressed ? 1 : 0)
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
