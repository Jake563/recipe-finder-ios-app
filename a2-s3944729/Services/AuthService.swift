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
    private static var error: String?
    private static var isAuthenticated: Bool = Auth.auth().currentUser != nil
    var userId: String? { Auth.auth().currentUser?.uid }
    
    enum SignUpError: Error {
        case emailTaken
        case invalidEmail
        case weakPassword
        case unknownError
    }
    
    
    //init() {
      //  Auth.auth().addStateDidChangeListener { [weak self] _, user in
        //    isAuthenticated = (user != nil)
        //}
    //}
    
    /// Creates an account with the given email and password
    static func signUp(email: String, password: String) async throws -> Bool {
        error = nil
        do {
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
            return true
        } catch {
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .emailAlreadyInUse:
                    throw SignUpError.emailTaken
                case .invalidEmail:
                    throw SignUpError.invalidEmail
                case .weakPassword:
                    throw SignUpError.weakPassword
                case .operationNotAllowed:
                    throw SignUpError.unknownError
                default:
                    throw SignUpError.unknownError
                }
            }
            print(error)
            self.error = error.localizedDescription
            print(self.error)
        }
        return false
    }
    
    /// Logs the user in
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
    
    /// Signs the current logged-in user out
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
