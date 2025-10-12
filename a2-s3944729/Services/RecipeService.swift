//
//  RecipeService.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 11/10/2025.
//

import SwiftData

class RecipeService {
    private var refreshRecipes = true
    private static let singleRecipeService = RecipeService()
    private let sharedContainer = try! makeSharedContainer()
    
    /// Returns a Singleton instance of Recipe Service
    static func getSingleRecipeService() -> RecipeService {
        return RecipeService.singleRecipeService
    }
    
    func shouldRefreshRecipes() -> Bool {
        if refreshRecipes == true {
            refreshRecipes = false
            return true
        }
        return false
    }
    
    func requestRecipeRefresh() {
        refreshRecipes = true
    }
    
    
    @MainActor
    private func clearOldRecentRecipes(context: ModelContext) throws {
        let recipes = try sharedContainer.mainContext.fetch(FetchDescriptor<StoredRecipe>().self)

        print("Going through recipes")
        for recipe in recipes {
            print(recipe.recipe.name)
            sharedContainer.mainContext.delete(recipe)
            //context.delete(recipe)
        }
    }
    
    @MainActor
    func saveRecentRecipes(recipes: [Recipe], context: ModelContext) {
        do {
            try clearOldRecentRecipes(context: context)
            
            for recipe in recipes {
                sharedContainer.mainContext.insert(StoredRecipe(recipe: recipe))
            }
            
            try sharedContainer.mainContext.save()
        } catch {
            print("Failed to save recipes: \(error)")
        }
    }
}
