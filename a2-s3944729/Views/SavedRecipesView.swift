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
        
        let yThreshold = (recipeIndex - pressedButtonIndex!) * (100)
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
        
        let yThreshold = (recipeIndex - pressedButtonIndex!) * (100)
        let isBelow = Int(buttonOffset) > yThreshold
        
        return isBelow
    }
    
    /// Returns what the offset a button should be.
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
    
    /// Returns the index change for the given offset.
    private func offsetToIndexChange(offset: Double) -> Int {
        return Int(offset / 100)
    }
    
    /// Updates the priority of the recipe based on the position its button was dragged to.
    private func updatePressedRecipeIndex() {
        print("CALLED")
        if pressedButtonIndex == nil {
            return
        }

        print("Current Index: \(pressedButtonIndex!)")
        print("Offset: \(buttonOffset)")
        let indexChange = offsetToIndexChange(offset: buttonOffset)
        let newIndex = pressedButtonIndex! + indexChange
        print("New Index: \(newIndex)")
  
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
                                let dragGesture = DragGesture()
                                    .onChanged{value in
                                        //print("Translation: \(value.translation.height)")
                                        buttonOffset = value.translation.height
                                        recipeBeingDraggedID = savedRecipe.id
                                        pressedButtonIndex = index
                                    }
                                    .onEnded { value in
                                        print("DRAG ENDED")
                                        updatePressedRecipeIndex()
                                        recipeBeingDraggedID = nil
                                        recipeBeingLongedPressedID = nil
                                        pressedButtonIndex = nil
                                        buttonOffset = 0
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

                                let recipeIsLongPressed = recipeBeingLongedPressedID == savedRecipe.id
                                
                                let isPressedRecipeAbove = isPressedRecipeAboveFunc(recipeIndex: index)
                                let isPressedRecipeBelow = isPressedRecipeBelowFunc(recipeIndex: index)
                                
                                let btnOffset = getButtonOffset(isAbove: isPressedRecipeAbove, isBelow: isPressedRecipeBelow, recipeIsPressed: recipeIsLongPressed)
                                
                                HStack {
                                    NavigationLink(destination: RecipeInfoView(recipe: savedRecipe.recipe)) {
                                        HStack {
                                            Text(String(index))
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
