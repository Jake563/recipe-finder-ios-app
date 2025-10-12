//
//  RecipeService.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 11/10/2025.
//

import SwiftData
import WidgetKit

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
        let recipes = try sharedContainer.mainContext.fetch(FetchDescriptor<RecipeOfTheDay>().self)

        print("Going through recipes")
        for recipe in recipes {
            print(recipe.name)
            sharedContainer.mainContext.delete(recipe)
        }
    }
    
    @MainActor
    func saveRecentRecipes(recipes: [Recipe], context: ModelContext) {
        do {
            try clearOldRecentRecipes(context: context)
            
            for recipe in recipes {
                let recipeOfTheDay = RecipeOfTheDay(
                    name: recipe.name,
                    estimatedTime: recipe.estimatedTime,
                    ingredients: recipe.ingredients,
                    instructions: recipe.instructions
                )
                sharedContainer.mainContext.insert(recipeOfTheDay)
            }
            
            try sharedContainer.mainContext.save()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("Failed to save recipes: \(error)")
        }
    }
}
