//
//  PrimaryButtonStyle.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 23/8/2025.
//

import SwiftUI

/// Style that stores the primary button styles.
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(16)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(16)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SquareButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(32)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
