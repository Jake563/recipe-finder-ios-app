//
//  SpeechToTextService.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 9/10/2025.
//
    
import SwiftUI
import Speech
import AVFoundation

/// Service responsible for converting Speech to Text
@MainActor
class SpeechToTextService: NSObject, ObservableObject {
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-AU"))!
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?

    @Published var transcript = ""
    @Published var audioLevel: Float = 0.0
    
    enum SpeechToTextServiceError: Error {
        case recordPermissionDenied
    }
    
    /// Requests the user the needed permissions to allow their speech to be converted to text. Returns true if access is granted.
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

    /// Starts converting the user's speech to text
    func startRecording() async throws {
        self.transcript = ""
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
            self.updateAudioLevel(buffer: buffer)
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

    /// Stops recording the user's speech to text
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        task?.cancel()
        task = nil
        request = nil
        self.audioLevel = 0.0
    }
    
    // Calculates how loud the user is speaking on a 0.0 to 1.0 scale.
    private func updateAudioLevel(buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else {
            return
        }
        let channelDataArray = Array(UnsafeBufferPointer(start: channelData, count: Int(buffer.frameLength)))

        // Compute RMS
        let rms = sqrt(channelDataArray.map { $0 * $0 }.reduce(0, +) / Float(buffer.frameLength))

        // Convert RMS to decibels
        let db = 20 * log10(rms)
        let minDb: Float = -80
        let level = max(0.0, min(1.0, (db + abs(minDb)) / abs(minDb))) // normalize 0–1

        DispatchQueue.main.async {
            self.audioLevel = level
        }
    }
}
