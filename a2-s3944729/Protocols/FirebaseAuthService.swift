//
//  AuthService.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 22/9/2025.
//

import FirebaseAuth

/// Acts as an interface of Firebase auth service, allowing real and mocked implementations
protocol FirebaseAuthServiceProtocol {
    func createUser(withEmail: String, password: String) async throws -> String?
    func signIn(email: String, password: String) async throws -> String?
    func signOut() async throws
    func currentUser() -> String?
}
