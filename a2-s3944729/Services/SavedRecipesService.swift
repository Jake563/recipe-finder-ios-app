//
//  SavedRecipesService.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 19/9/2025.
//

import Foundation
import FirebaseFirestore

/// Service that is responsible for storing and retrieving saved recipes in cloud storage for the current signed-in user.
final class SavedRecipesService {
    static private let authService = AuthService.getAuthService()
    static private let db = Firestore.firestore()
    static private let SAVED_RECIPES_COLLECTION_NAME = "saved-recipes"

    enum Errors: Error {
        case noAuthenticatedUser
    }
    
    /// Gets all the recipes in the database.
    static func getRecipes() async throws -> [SavedRecipe] {
        let userId = authService.getUserId()

        if userId == nil {
            throw Errors.noAuthenticatedUser
        }
        
        let queryResult = try await db.collection(SAVED_RECIPES_COLLECTION_NAME)
            .whereField("userId", isEqualTo: userId!)
            .order(by: "priority")
            .getDocuments()
        let documents = queryResult.documents
        let savedRecipes: [SavedRecipe] = documents.compactMap {
            try? $0.data(as: SavedRecipe.self)
        }
        
        return savedRecipes
    }
    
    /// Adds the given recipe to the database.
    static func addRecipe(recipe: Recipe) async throws -> String {
        let userId = authService.getUserId()
        
        if userId == nil {
            throw Errors.noAuthenticatedUser
        }
        
        let allRecipesQueryResult = try await db.collection(SAVED_RECIPES_COLLECTION_NAME)
            .whereField("userId", isEqualTo: userId!)
            .getDocuments()
        let savedRecipe = SavedRecipe(userId: userId!, priority: allRecipesQueryResult.count, recipe: recipe)
        let queryResult = try db.collection(SAVED_RECIPES_COLLECTION_NAME).addDocument(from: savedRecipe) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
            }
        }
        return queryResult.documentID
    }
    
    /// Deletes the recipe with the given recipe ID from the database.
    static func deleteRecipe(savedRecipeId: String) throws {
        let userId = authService.getUserId()
        
        if userId == nil {
            throw Errors.noAuthenticatedUser
        }
        
        db.collection(SAVED_RECIPES_COLLECTION_NAME).document(savedRecipeId).delete()
    }
    
    /// Changes the priority of the given recipes list.
    static func changeRecipeOrder(recipesToUpdate: [(id: String, newPriority: Int)]) throws {
        let userId = authService.getUserId()
        
        if userId == nil {
            throw Errors.noAuthenticatedUser
        }
        
        let batch = db.batch()
        
        for (id, newPriority) in recipesToUpdate {
            let docRef = db.collection(SAVED_RECIPES_COLLECTION_NAME).document(id)
            batch.updateData(["priority": newPriority], forDocument: docRef)
        }
        batch.commit()
    }
}
