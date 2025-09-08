//
//  AppLogoLayout.swift
//  assignment-1
//
//  Custom layout that assists with the layout of the app's logo.
//
//  Created by Jake Parkinson on 24/8/2025.
//

import SwiftUI

struct AppLogoLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(proposal) }
        
        let maxWidth = sizes.map { $0.width }.max() ?? 0
        let maxHeight = sizes.map { $0.height }.max() ?? 0
        
        let angle: CGFloat = .pi / 4
        let rotatedWidth = maxWidth * cos(angle) + maxHeight * sin(angle)
        let rotatedHeight = maxHeight * cos(angle) + maxWidth * sin(angle)
        
        return CGSize(width: rotatedWidth, height: rotatedHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let centerAx = bounds.origin.x + (bounds.width / 2)
        let centerAy = bounds.origin.y + (bounds.height / 2)
        subviews[0].place(at: CGPoint(x: centerAx - 20, y: centerAy + 20), anchor: .center, proposal: .unspecified)
        subviews[1].place(at: CGPoint(x: centerAx, y: centerAy), anchor: .center, proposal: .unspecified)
        subviews[2].place(at: CGPoint(x: centerAx + 20, y: centerAy - 20), anchor: .center, proposal: .unspecified)
    }
}
