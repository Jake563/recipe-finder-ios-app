//
//  StoredRecipeContainter.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 12/10/2025.
//

import SwiftData
import Foundation

func makeSharedContainer() throws -> ModelContainer {
    let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.leftovers")!
    let storeURL = groupURL.appendingPathComponent("Recipes.swiftdata")

    // Create a persistent configuration
    let config = ModelConfiguration(url: storeURL)

    // Create container for Recipe
    let container = try ModelContainer(for: StoredRecipe.self, configurations: config)
    return container
}
