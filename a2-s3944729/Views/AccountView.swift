//
//  AccountView.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 18/9/2025.
//

import SwiftUI

struct AccountView: View {
    @State private var enteredEmail: String = ""
    @State private var enteredPassword: String = ""
    
    @State private var emailError: String = ""
    @State private var passwordError: String = ""
    
    @State private var onLoginView = true;
    @State private var loggedIn = false;
    
    private func displaySignUpErrorFromError(error: Error) {
        if error as! AuthService.SignUpError == AuthService.SignUpError.emailTaken {
            emailError = "Email is taken"
            return
        }
        if error as! AuthService.SignUpError == AuthService.SignUpError.invalidEmail {
            emailError = "Invalid email"
            return
        }
        if error as! AuthService.SignUpError == AuthService.SignUpError.weakPassword {
            passwordError = "Password is weak"
            return
        }
        passwordError = "Unknown error occured"
    }
    
    private func displaySignInErrorFromError(error: Error) {
        if error as! AuthService.SignInError == AuthService.SignInError.invalidEmail {
            emailError = "Invalid email"
            return
        }
        if error as! AuthService.SignInError == AuthService.SignInError.notFound {
            passwordError = "Account not found"
            return
        }
        if error as! AuthService.SignInError == AuthService.SignInError.wrongPassword {
            passwordError = "Incorrect password"
            return
        }
        passwordError = "Unknown error occured"
    }
    
    private func login() {
        Task {
            do {
                try await AuthService.signIn(email: enteredEmail, password: enteredPassword)
                loggedIn = true
            } catch {
                displaySignInErrorFromError(error: error)
            }
        }
    }
    
    private func signup() {
        Task {
            do {
                try await AuthService.signUp(email: enteredEmail, password: enteredPassword)
                loggedIn = true
            } catch {
                print(error)
                displaySignUpErrorFromError(error: error)
            }
        }
    }
    
    private func logout() {
        let success = AuthService.signOut()
        
        if !success {
            return
        }
        loggedIn = false
    }
    
    var body: some View {
        NavigationStack {
            if loggedIn {
                Button(action: {
                    logout()
                }) {
                    Text("Logout")
                }
            } else {
                VStack(spacing: 40) {
                    VStack(spacing: 20) {
                        VStack {
                            TextField("Email", text: $enteredEmail)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1)
                                )
                                .font(.title)
                            if !emailError.isEmpty {
                                HStack {
                                    Text(emailError)
                                        .foregroundStyle(.red)
                                    Spacer()
                                }
                            }
                        }
                        VStack {
                            TextField("Password", text: $enteredPassword)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1)
                                )
                                .font(.title)
                            if !passwordError.isEmpty {
                                HStack {
                                    Text(passwordError)
                                        .foregroundStyle(.red)
                                    Spacer()
                                }
                            }
                        }
                    }
                    Button(action: {
                        emailError = ""
                        passwordError = ""
                        if onLoginView {
                            login()
                        } else {
                            signup()
                        }
                    }) {
                        Text(onLoginView ? "Login" : "Sign Up")
                            .frame(maxWidth: .infinity)
                            .font(.title)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    HStack {
                        Spacer()
                        Button(action: {
                            onLoginView = !onLoginView
                        }) {
                            Text(onLoginView ? "Create an account" : "Login")
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Account")
                            .font(.title)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    AccountView()
}
