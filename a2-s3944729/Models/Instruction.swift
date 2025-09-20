//
//  Instruction.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 9/9/2025.
//

import Foundation

struct Instruction: Identifiable, Codable {
    let id = UUID()
    let instruction: String
    let timer: Int
    
    enum CodingKeys: String, CodingKey {
        case instruction = "instruction"
        case timer = "timer"
    }
}
