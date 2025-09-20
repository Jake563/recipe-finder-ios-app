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
