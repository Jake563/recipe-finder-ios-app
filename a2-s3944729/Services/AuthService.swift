//
//  AuthService.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 18/9/2025.
//

import Foundation
import FirebaseAuth

final class AuthService {
    private static var error: String?
    private static var isAuthenticated: Bool = Auth.auth().currentUser != nil
    
    var userId: String? { Auth.auth().currentUser?.uid }
    
    //init() {
      //  Auth.auth().addStateDidChangeListener { [weak self] _, user in
        //    isAuthenticated = (user != nil)
        //}
    //}
    
    static func signUp(email: String, password: String) async -> Bool {
        error = nil
        do {
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
            return true
        } catch {
            self.error = error.localizedDescription
            print(self.error)
        }
        return false
    }
    
    static func signIn(email: String, password: String) async -> Bool {
        error = nil
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            return true
        } catch {
            self.error = error.localizedDescription
            print(self.error)
        }
        return false
    }
    
    static func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            self.error = error.localizedDescription
        }
        return false
    }
}
