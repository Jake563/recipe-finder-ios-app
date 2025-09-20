//
//  AuthService.swift
//  a2-s3944729
//
//  Service that is responsible for handling auth related actions, such as logging in.
//
//  Created by Jake Parkinson on 18/9/2025.
//

import Foundation
import FirebaseAuth

final class AuthService {
    private static var isAuthenticated: Bool = Auth.auth().currentUser != nil
    private static var userId: String? = Auth.auth().currentUser?.uid
    
    /// Errors that can occur during sign-in/sign-up
    enum AuthError: Error {
        case emailTaken
        case invalidEmail
        case accountNotFound
        case wrongPassword
        case weakPassword
        case unknownError
    }
    
    /// Creates an account with the given email and password
    static func signUp(email: String, password: String) async throws {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            userId = authResult.user.uid
        } catch {
            print("Sign up error: " + error.localizedDescription)
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .emailAlreadyInUse:
                    throw AuthError.emailTaken
                case .invalidEmail:
                    throw AuthError.invalidEmail
                case .weakPassword:
                    throw AuthError.weakPassword
                default:
                    throw AuthError.unknownError
                }
            }
        }
    }
    
    /// Logs the user in
    static func signIn(email: String, password: String) async throws {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            userId = authResult.user.uid
        } catch {
            if let error = error as NSError? {
                print("Sign In error: " + error.localizedDescription)
                switch AuthErrorCode(rawValue: error.code) {
                case .invalidEmail:
                    throw AuthError.invalidEmail
                case .userNotFound:
                    throw AuthError.accountNotFound
                case .wrongPassword:
                    throw AuthError.wrongPassword
                default:
                    throw AuthError.unknownError
                }
            }
        }
    }
    
    /// Signs the current logged-in user out
    static func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            userId = nil
            return true
        } catch {
            print("Sign out error: " + error.localizedDescription)
        }
        return false
    }
    
    /// Returns the ID of the user who is currently signed-in
    static func getUserId() -> String? {
        return userId
    }
    
    /// Returns whether the user is logged in or not
    static func isLoggedIn() -> Bool {
        return userId != nil
    }
}
