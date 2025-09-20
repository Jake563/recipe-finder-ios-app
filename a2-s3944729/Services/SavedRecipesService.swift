//
//  SavedRecipesService.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 19/9/2025.
//

import Foundation
import FirebaseFirestore

final class SavedRecipesService {
    static private let db = Firestore.firestore()
    private var notesListener: ListenerRegistration?
    
    enum Errors: Error {
        case noAuthenticatedUser
    }
    
    func stopObserving() {
        notesListener?.remove(); notesListener = nil
    }
    
    static func getRecipes() async throws -> [SavedRecipe] {
        let userId = AuthService.getUserId()
        
        if userId == nil {
            throw Errors.noAuthenticatedUser
        }
        
        let queryResult = try await db.collection("recipes").whereField("userId", isEqualTo: userId).getDocuments()
        let documents = queryResult.documents
        let savedRecipes: [SavedRecipe] = documents.compactMap {
            try? $0.data(as: SavedRecipe.self)
        }
        
        return savedRecipes
    }
    
    static func addRecipe(recipe: Recipe) throws {
        let userId = AuthService.getUserId()
        
        if userId == nil {
            throw Errors.noAuthenticatedUser
        }
        
        let savedRecipe = SavedRecipe(userId: userId!, recipe: recipe)
        print(savedRecipe)
        _ = try db.collection("recipes").addDocument(from: savedRecipe) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
            }
        }
    }
}
