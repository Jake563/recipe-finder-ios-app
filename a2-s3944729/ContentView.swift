//
//  ContentView.swift
//  a2-s3944729
//
//  View that introduces the user to the app.
// 
//  Created by Jake Parkinson on 8/9/2025.
//

import SwiftUI

private struct CustomRectangle: View {
    var color: Color
    var rotation: Double
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: 100, height: 160)
            .border(Color.black, width: 2)
            .rotationEffect(.degrees(rotation))
    }
}

private struct AppLogo: View {
    var body: some View {
        AppLogoLayout {
            CustomRectangle(color: Color(red: 137 / 255, green: 1.0, blue: 231 / 255), rotation: -30) // green
            CustomRectangle(color: Color(red: 161 / 255, green: 148 / 255, blue: 1.0), rotation: -20) // purple
            CustomRectangle(color: Color(red: 1.0, green: 113 / 255, blue: 246 / 255), rotation: -10) // pink
            Text("LeftOvers")
                .foregroundStyle(.black)
                .font(.system(size: 35, design: .serif))
                .italic()
                .fontWeight(.heavy)
            Text("LeftOvers")
                .foregroundStyle(.white)
                .font(.system(size: 35, design: .serif))
                .offset(x: -3, y: -3)
                .italic()
                .fontWeight(.heavy)
        }
    }
}

struct ContentView: View {
    @State private var showMainView = false
    
    var body: some View {
        if showMainView {
            MainView()
        } else {
            VStack {
                AppLogo()
                Spacer()
                Text("Discover what you can make with your leftover ingredients!")
                    .multilineTextAlignment(.center)
                    .font(.title)
                Spacer()
                Button(action: {
                    showMainView = true
                }) {
                    Text("Get Started")
                    .frame(maxWidth: .infinity)
                    .font(.title)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
