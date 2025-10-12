//
//  RecipeService.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 11/10/2025.
//

import SwiftData
import WidgetKit

/// Service responsible for managing recipes.
class RecipeService {
    private var refreshRecipes = false
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
    private func clearOldRecentRecipes() throws {
        let recipes = try sharedContainer.mainContext.fetch(FetchDescriptor<RecentRecipe>().self)

        print("Going through recipes")
        for recipe in recipes {
            print(recipe.name)
            sharedContainer.mainContext.delete(recipe)
        }
    }
    
    @MainActor
    func saveRecentRecipes(recipes: [Recipe]) {
        do {
            try clearOldRecentRecipes()
            
            for recipe in recipes {
                let RecentRecipe = RecentRecipe(
                    name: recipe.name,
                    estimatedTime: recipe.estimatedTime,
                    ingredients: recipe.ingredients,
                    instructions: recipe.instructions
                )
                sharedContainer.mainContext.insert(RecentRecipe)
            }
            
            try sharedContainer.mainContext.save()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("Failed to save recipes: \(error)")
        }
    }
    
    @MainActor
    func getRecentRecipes() -> [Recipe] {
        do {
            let storedRecipes = try sharedContainer.mainContext.fetch(FetchDescriptor<RecentRecipe>())
            var recipes: [Recipe] = []
            
            for storedRecipe in storedRecipes {
                let recipe: Recipe = Recipe(
                    name: storedRecipe.name,
                    estimatedTime: storedRecipe.estimatedTime,
                    ingredients: storedRecipe.ingredients,
                    instructions: storedRecipe.instructions
                )
                recipes.append(recipe)
            }
            
            print("Loaded \(recipes.count) recent recipes")
            return recipes
        } catch {
            print("Failed to get recent recipes: \(error)")
        }
        return []
    }
}
