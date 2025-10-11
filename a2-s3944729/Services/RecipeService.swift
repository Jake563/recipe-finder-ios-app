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
    
    private func clearOldRecentRecipes(context: ModelContext) throws {
        let recipes = try context.fetch(FetchDescriptor<StoredRecipe>().self)

        print("Going through recipes")
        for recipe in recipes {
            print(recipe.recipe.name)
            context.delete(recipe)
        }
    }
    
    func saveRecentRecipes(recipes: [Recipe], context: ModelContext) {
        do {
            try clearOldRecentRecipes(context: context)
            
            for recipe in recipes {
                context.insert(StoredRecipe(recipe: recipe))
            }
            
            try context.save()
        } catch {
            print("Failed to save recipes: \(error)")
        }
    }
}
