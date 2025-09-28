//
//  DailyRecipeWidgetBundle.swift
//  DailyRecipeWidget
//
//  Created by Jake Parkinson on 28/9/2025.
//

import WidgetKit
import SwiftUI

@main
struct DailyRecipeWidgetBundle: WidgetBundle {
    var body: some Widget {
        DailyRecipeWidget()
        DailyRecipeWidgetControl()
        DailyRecipeWidgetLiveActivity()
    }
}
