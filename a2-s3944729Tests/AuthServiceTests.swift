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
    var errorToThrow: Error?
    
    func createUser(withEmail: String, password: String) async throws -> String? {
        if errorToThrow != nil {
            throw errorToThrow!
        }
        return signedInUserID
    }
    
    func signIn(email: String, password: String) async throws -> String? {
        if errorToThrow != nil {
            throw errorToThrow!
        }
        return signedInUserID
    }
    
    func signOut(withEmail: String, password: String) async throws {
        if errorToThrow != nil {
            throw errorToThrow!
        }
    }

    func currentUser() -> String? {
        return signedInUserID
    }
}

struct AuthServiceTests {
    @Test func testSignUp_unknownError_throwsUnknownError() async throws {
        let mockFirebaseAuthService = MockFirebaseAuthService()
        mockFirebaseAuthService.errorToThrow = NSError(domain: "domain", code: -123)
        let authService = AuthService(firebaseAuthService: mockFirebaseAuthService)

        await #expect(throws: AuthService.AuthError.unknownError) {
            try await authService.signUp(email: "test@test.com", password: "password")
        }
    }
    
    @Test func testSignUp_weakPassword_throwsWeakPasswordError() async throws {
        let WEAK_PASSWORD_CODE = 17026
        let mockFirebaseAuthService = MockFirebaseAuthService()
        mockFirebaseAuthService.errorToThrow = NSError(domain: "FIRAuthErrorDomain", code: WEAK_PASSWORD_CODE)
        let authService = AuthService(firebaseAuthService: mockFirebaseAuthService)

        await #expect(throws: AuthService.AuthError.weakPassword) {
            try await authService.signUp(email: "test@test.com", password: "123")
        }
    }
    
    @Test func testSignIn_accountDoesNotExist_throwsAccountNotFoundError() async throws {
        let ACCOUNT_NOT_FOUND_ERROR_CODE = 17011
        let mockFirebaseAuthService = MockFirebaseAuthService()
        mockFirebaseAuthService.errorToThrow = NSError(domain: "FIRAuthErrorDomain", code: ACCOUNT_NOT_FOUND_ERROR_CODE)
        let authService = AuthService(firebaseAuthService: mockFirebaseAuthService)

        await #expect(throws: AuthService.AuthError.accountNotFound) {
            try await authService.signIn(email: "non-exist@test.com", password: "123")
        }
    }
    
    @Test func testSignIn_signInSucceeds_throwsNoError() async throws {
        let mockFirebaseAuthService = MockFirebaseAuthService()
        let authService = AuthService(firebaseAuthService: mockFirebaseAuthService)

        try await authService.signIn(email: "test@test.com", password: "chsbhabdshasdjn")
        
        // This test will pass if signIn throws no error, hence why there is no #expect here.
    }
    
    @Test func testIsLoggedIn_nonNilUserId_returnsTrue() async throws {
        let mockFirebaseAuthService = MockFirebaseAuthService()
        mockFirebaseAuthService.signedInUserID = "signed-in-user-id"
        let authService = AuthService(firebaseAuthService: mockFirebaseAuthService)
        
        let loggedIn = authService.isLoggedIn()
        
        #expect(loggedIn == true)
    }
    
    @Test func testIsLoggedIn_nilUserId_returnsFalse() async throws {
        let mockFirebaseAuthService = MockFirebaseAuthService()
        mockFirebaseAuthService.signedInUserID = nil
        let authService = AuthService(firebaseAuthService: mockFirebaseAuthService)
        
        let loggedIn = authService.isLoggedIn()
        
        #expect(loggedIn == false)
    }
}
