//
//  MeditaidWidgetExtensionBundle.swift
//  MeditaidWidgetExtension
//
//  Created by Krzysztof Garmulewicz on 01/12/2025.
//

import WidgetKit
import SwiftUI

@main
struct MeditaidWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        MeditaidWidget()
        // MeditaidWidgetExtensionControl()
        TimerActivityConfiguration()
    }
}
