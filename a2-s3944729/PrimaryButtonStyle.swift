//
//  PrimaryButtonStyle.swift
//  assignment-1
//
//  Style that stores the primary button styles.
//
//  Created by Jake Parkinson on 23/8/2025.
//

import SwiftUI

let PRIMARY_BUTTON_COLOUR = Color(red:0.95, green:0.95, blue:0.95)

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(16)
            .background(configuration.isPressed ? Color.white.opacity(0.6) : PRIMARY_BUTTON_COLOUR)
            .foregroundColor(.black)
            .cornerRadius(16)
    }
}

struct SquareButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(configuration.isPressed ? Color.white.opacity(0.6) : PRIMARY_BUTTON_COLOUR)
            .foregroundColor(.black)
            .cornerRadius(32)
    }
}
