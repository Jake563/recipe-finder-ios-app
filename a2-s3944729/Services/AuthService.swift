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

private class FirebaseAuthService: FirebaseAuthServiceProtocol {
    func createUser(withEmail: String, password: String) async throws -> String? {
        return try await Auth.auth().createUser(withEmail: withEmail, password: password).user.uid
    }

    func signIn(email: String, password: String) async throws -> String? {
        return try await Auth.auth().signIn(withEmail: email, password: password).user.uid
    }
    
    func signOut() async throws {
        return try Auth.auth().signOut()
    }

    func currentUser() -> String? {
        return Auth.auth().currentUser?.uid
    }
}

final class AuthService {
    private let firebaseAuthService: FirebaseAuthServiceProtocol
    private var isAuthenticated: Bool
    private var userId: String?
    private static let authService = AuthService(firebaseAuthService: FirebaseAuthService())
    
    /// Errors that can occur during sign-in/sign-up
    enum AuthError: Error {
        case emailTaken
        case invalidEmail
        case accountNotFound
        case wrongPassword
        case weakPassword
        case unknownError
    }
    
    init(firebaseAuthService: FirebaseAuthServiceProtocol) {
        self.firebaseAuthService = firebaseAuthService
        self.isAuthenticated = firebaseAuthService.currentUser() != nil
        self.userId = firebaseAuthService.currentUser()
    }
    
    // Singleton
    static func getAuthService() -> AuthService {
        return AuthService.authService
    }
    
    /// Creates an account with the given email and password
    func signUp(email: String, password: String) async throws {
        do {
            userId = try await firebaseAuthService.createUser(withEmail: email, password: password)
            return
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
        throw AuthError.unknownError
    }
    
    /// Logs the user in
    func signIn(email: String, password: String) async throws {
        do {
            userId = try await firebaseAuthService.signIn(email: email, password: password)
            return
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
        throw AuthError.unknownError
    }
    
    /// Signs the current logged-in user out
    func signOut() async -> Bool {
        do {
            try await firebaseAuthService.signOut()
            userId = nil
            return true
        } catch {
            print("Sign out error: " + error.localizedDescription)
        }
        return false
    }
    
    /// Returns the ID of the user who is currently signed-in
    func getUserId() -> String? {
        return userId
    }
    
    /// Returns whether the user is logged in or not
    func isLoggedIn() -> Bool {
        return userId != nil
    }
}
