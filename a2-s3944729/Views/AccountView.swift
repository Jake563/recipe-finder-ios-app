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
    
    @State private var onLoginView = true;
    @State private var loggedIn = false;
    
    private func login() {
        Task {
            let success = await AuthService.signIn(email: enteredEmail, password: enteredPassword)
            
            if !success {
                return
            }
            loggedIn = true
        }
    }
    
    private func signup() {
        Task {
            let success = await AuthService.signUp(email: enteredEmail, password: enteredPassword)
            
            if !success {
                return
            }
            loggedIn = true
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
                        TextField("Email", text: $enteredEmail)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1)
                            )
                            .font(.title)
                        TextField("Password", text: $enteredPassword)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1)
                            )
                            .font(.title)
                    }
                    Button(action: {
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
