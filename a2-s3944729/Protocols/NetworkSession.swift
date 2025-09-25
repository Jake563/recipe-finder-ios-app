//
//  NetworkSession.swift
//  a2-s3944729
//
//  Created by Jake Parkinson on 20/9/2025.
//

import Foundation
import FirebaseAuth

/// Acts as an interface of Network Session, allowing real and mocked implementations
protocol NetworkSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession {}
