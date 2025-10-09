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
    
    /// Requests the user permission to record their voice. Returns true if access is granted.
    func requestSpeechPermission() -> Bool {
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            case .authorized:
                print("Speech recognition authorized")
            case .denied:
                print("Speech recognition denied")
            default:
                print("Speech recognition unavailable")
            }
        }
        
        var isGranted = false
        
        AVAudioApplication.requestRecordPermission { granted in
            print(granted ? "Mic access granted" : "Mic access denied")
            isGranted = granted
        }
        
        return isGranted
    }

    func startRecording() throws {
        if !requestSpeechPermission() {
            return
        }
        
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
    }
}
