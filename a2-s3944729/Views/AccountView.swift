//
//  AccountView.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 18/9/2025.
//

import SwiftUI

struct AccountView: View {
    @State private var enteredUsername: String = ""
    @State private var enteredPassword: String = ""
    
    @State private var onLoginView = true;
    
    private func login() {
        
    }
    
    private func signup() {
        
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                VStack(spacing: 20) {
                    TextField("Username", text: $enteredUsername)
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

#Preview {
    AccountView()
}
