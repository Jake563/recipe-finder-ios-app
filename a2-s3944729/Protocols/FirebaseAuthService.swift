//
//  AuthService.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 22/9/2025.
//

import FirebaseAuth

protocol FirebaseAuthServiceProtocol {
    func createUser(withEmail: String, password: String) async throws -> String?
    func signIn(email: String, password: String) async throws -> String?
    func signOut(withEmail: String, password: String) async throws
    func currentUser() -> String?
}
