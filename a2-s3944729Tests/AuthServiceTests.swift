//
//  AuthServiceTests.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 22/9/2025.
//

import Testing
import FirebaseAuth
@testable import a2_s3944729
import Foundation

private class MockFirebaseAuthService: FirebaseAuthServiceProtocol {
    var signedInUserID: String?
    var shouldThrowError = false
    var errorToThrow: Error? = NSError(domain: "domain", code: 1)
    
    func createUser(withEmail: String, password: String) async throws -> String? {
        if shouldThrowError {
            throw errorToThrow!
        }
        return signedInUserID
    }
    
    func signIn(email: String, password: String) async throws -> String? {
        if shouldThrowError {
            throw errorToThrow!
        }
        return signedInUserID
    }
    
    func signOut(withEmail: String, password: String) async throws {
        if shouldThrowError {
            throw errorToThrow!
        }
    }

    func currentUser() -> String? {
        return signedInUserID
    }
}

struct AuthServiceTests {
    @Test func testSignUp_networkFailure_returnsUnknownError() async throws {
        let mockFirebaseAuthService = MockFirebaseAuthService()
        mockFirebaseAuthService.shouldThrowError = true
        let authService = AuthService(firebaseAuthService: mockFirebaseAuthService)

        await #expect(throws: AuthService.AuthError.unknownError) {
            _ = try await authService.signUp(email: "test@test.com", password: "password")
        }
    }
    
    @Test func testSignUp_weakPassword_returnsWeakPasswordError() async throws {
        let WEAK_PASSWORD_CODE = 17026
        let mockFirebaseAuthService = MockFirebaseAuthService()
        mockFirebaseAuthService.shouldThrowError = true
        mockFirebaseAuthService.errorToThrow = NSError(domain: "FIRAuthErrorDomain", code: WEAK_PASSWORD_CODE)
        let authService = AuthService(firebaseAuthService: mockFirebaseAuthService)

        await #expect(throws: AuthService.AuthError.weakPassword) {
            _ = try await authService.signUp(email: "test@test.com", password: "123")
        }
    }
    
    @Test func testSignIn_accountDoesNotExist_throwsAccountNotFoundError() async throws {
        let ACCOUNT_NOT_FOUND_ERROR_CODE = 17011
        let mockFirebaseAuthService = MockFirebaseAuthService()
        mockFirebaseAuthService.shouldThrowError = true
        mockFirebaseAuthService.errorToThrow = NSError(domain: "FIRAuthErrorDomain", code: ACCOUNT_NOT_FOUND_ERROR_CODE)
        let authService = AuthService(firebaseAuthService: mockFirebaseAuthService)

        await #expect(throws: AuthService.AuthError.accountNotFound) {
            _ = try await authService.signIn(email: "non-exist@test.com", password: "123")
        }
    }
    
    @Test func testSignIn_networkFailure_returnsUnknownError() async throws {
        struct GenericError: Error {}
        
        let mockFirebaseAuthService = MockFirebaseAuthService()
        mockFirebaseAuthService.shouldThrowError = true
        mockFirebaseAuthService.errorToThrow = GenericError()
        let authService = AuthService(firebaseAuthService: mockFirebaseAuthService)

        await #expect(throws: AuthService.AuthError.unknownError) {
            _ = try await authService.signIn(email: "test@test.com", password: "123")
        }
    }
    
    @Test func testIsLoggedIn_userLoggedIn_returnsTrue() async throws {
        let mockFirebaseAuthService = MockFirebaseAuthService()
        mockFirebaseAuthService.signedInUserID = "signed-in-user-id"
        let authService = AuthService(firebaseAuthService: mockFirebaseAuthService)
        
        let loggedIn = authService.isLoggedIn()
        
        #expect(loggedIn == true)
    }
    
    @Test func testIsLoggedIn_userNotLoggedIn_returnsFalse() async throws {
        let mockFirebaseAuthService = MockFirebaseAuthService()
        mockFirebaseAuthService.signedInUserID = nil
        let authService = AuthService(firebaseAuthService: mockFirebaseAuthService)
        
        let loggedIn = authService.isLoggedIn()
        
        #expect(loggedIn == false)
    }
}
