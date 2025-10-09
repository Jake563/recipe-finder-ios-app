//
//  IntelligentPersonalAssistantView.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 9/10/2025.
//

import SwiftUI

struct IntelligentPersonalAssistantView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                AIResponseDialog(text: "How can I help?")
            }
            .padding(.horizontal)
            HStack {
                Spacer()
                Button(action: {
                    
                }) {
                    ZStack {
                        Image(systemName: "microphone.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(30)
                    .background(
                        Circle()
                            .fill(Color.black)
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                AngularGradient(
                                    colors: [.red, .orange, .yellow, .green, .blue, .purple, .red],
                                    center: .center
                                ),
                                lineWidth: 5
                            )
                    )
                    .shadow(radius: 5)
                }
            }
            .padding()
        }
        .padding(.vertical, 50)
    }
}

private struct AIResponseDialog: View {
    let text: String

    var body: some View {
        VStack(spacing: 0) {
            // Main bubble
            Text(text)
                .font(.body)
                .foregroundColor(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white)
                )
                .shadow(radius: 5)

            DialogTail()
                .fill(Color.black)
                .frame(width: 20, height: 20)
                .rotationEffect(.degrees(90)) // rotate so it points right
                .offset(x: 0, y: -5) // position next to the bubble
        }
        .frame(maxWidth: 250, alignment: .trailing)
    }
}

private struct DialogTail: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.height)) // bottom-left
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2)) // tip
        path.addLine(to: CGPoint(x: 0, y: 0)) // top-left
        path.closeSubpath()

        return path
    }
}

#Preview {
    IntelligentPersonalAssistantView()
}
