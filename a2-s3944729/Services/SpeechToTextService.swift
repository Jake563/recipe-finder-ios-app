//
//  SpeechToTextService.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 9/10/2025.
//
    
import SwiftUI
import Speech
import AVFoundation

class SpeechToTextService: NSObject, ObservableObject {
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-AU"))!
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?

    @Published var transcript = ""
    
    enum SpeechToTextServiceError: Error {
        case recordPermissionDenied
    }
    
    /// Requests the user permission to record their voice. Returns true if access is granted.
    func requestSpeechPermission() async -> Bool {
        let speechGranted = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                switch status {
                case .authorized:
                    print("Speech recognition granted")
                    continuation.resume(returning: true)
                case .denied:
                    print("Speech recognition denied")
                    continuation.resume(returning: false)
                default:
                    print("Speech recognition unavailable")
                    continuation.resume(returning: false)
                }
            }
        }

        let micGranted = await AVAudioApplication.requestRecordPermission()
        if micGranted {
            print("Mic access granted")
        } else {
            print("Mic access denied")
        }
        
        return micGranted && speechGranted
    }

    func startRecording() async throws {
        if !(await requestSpeechPermission()) {
            print("User rejected permission to record.")
            throw SpeechToTextServiceError.recordPermissionDenied
        }
        print("Access granted to start recording.")
        
        // Reset if already running
        stopRecording()
        
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .measurement, options: .duckOthers)
        try session.setActive(true, options: .notifyOthersOnDeactivation)
        
        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request = request else {
            return
        }
        request.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            request.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        task = recognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.transcript = result.bestTranscription.formattedString
                }
            }
            
            if error != nil {
                self.stopRecording()
            }
        }
    }

    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        task?.cancel()
        task = nil
        request = nil
    }
}
