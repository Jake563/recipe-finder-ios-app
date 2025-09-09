//
//  Instruction.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 9/9/2025.
//

import Foundation

struct Instruction: Codable, Identifiable {
    let id: UUID = UUID()
    let instruction: String
    let timer: Int
}
