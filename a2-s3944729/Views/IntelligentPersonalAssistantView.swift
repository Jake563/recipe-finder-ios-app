//
//  IntelligentPersonalAssistantView.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 9/10/2025.
//

import SwiftUI

struct IntelligentPersonalAssistantView: View {
    private static let INITIAL_DIALOG_TEXT = "How can I help?"
    
    @Environment(\.modelContext) private var context
    @State private var recording = false
    @State private var loadingAiResponse = false
    @State private var showDialog = false
    @State private var showAlert = false
    @State private var dialogText = IntelligentPersonalAssistantView.INITIAL_DIALOG_TEXT
    @StateObject private var speechToTextService = SpeechToTextService()
    
    private func startRecording() {
        Task {
            do {
                try await speechToTextService.startRecording()
                recording = true
                showDialog = true
            } catch {
                print("Failed to start recording: \(error)")
                
                let speechToTextError = error as! SpeechToTextService.SpeechToTextServiceError
                
                if speechToTextError == SpeechToTextService.SpeechToTextServiceError.recordPermissionDenied {
                    showAlert = true
                }
            }
        }
    }
    
    private func stopRecording() {
        speechToTextService.stopRecording()
        recording = false
        loadingAiResponse = true
        let intelligentAssistantService = IntelligentAssistantService(context: context)
        print("Transcript: '\(speechToTextService.transcript)'")
        
        Task {
            dialogText = await intelligentAssistantService.performActions(userRequest: speechToTextService.transcript)
            loadingAiResponse = false
        }
    }
    
    private func exitAssistant() {
        speechToTextService.stopRecording()
        recording = false
        showDialog = false
        dialogText = IntelligentPersonalAssistantView.INITIAL_DIALOG_TEXT
    }
    
    var body: some View {
        ZStack {
            if showDialog {
                ZStack {
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle()) // Makes the entire ZStack tappable
                .onTapGesture {
                    exitAssistant()
                }
            }
            VStack {
                Spacer()
                if showDialog {
                    HStack {
                        Spacer()
                        AIResponseDialog(text: dialogText, loading: loadingAiResponse)
                    }
                    .padding(.horizontal)
                }
                HStack {
                    Spacer()
                    Button(action: {
                        if recording {
                            stopRecording()
                        } else {
                            startRecording()
                        }
                    }) {
                        ZStack {
                            Image(systemName: "microphone.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        }
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(20)
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
                        .scaleEffect(CGFloat(1 + speechToTextService.audioLevel))
                        .animation(.easeOut(duration: 0.05), value: speechToTextService.audioLevel)
                    }
                }
                .padding()
            }
            .padding(.vertical, 50)
            .alert("Intelligent Assistant Unavailable", isPresented: $showAlert) {
                Button("OK", role: .cancel) {
                }
            } message: {
                Text("You must grant Microphone and Speech Recognition permissions to use the Personal Intelligent Assistant.")
            }
        }
    }
}

private struct AIResponseDialog: View {
    let text: String
    let loading: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Main bubble
            ZStack {
                if loading {
                    ThreeDotsLoadingView()
                } else {
                    Text(text)
                }
            }
            .frame(minWidth: 100)
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
                .rotationEffect(.degrees(90))
                .offset(x: 0, y: -5)
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

private struct ThreeDotsLoadingView: View {
    @State private var animate = false

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 10, height: 10)
                    .scaleEffect(animate ? 1 : 0.5)
                    .animation(
                        Animation
                            .easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    IntelligentPersonalAssistantView()
}
