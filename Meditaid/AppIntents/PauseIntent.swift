//
//  PauseAppIntent.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 02/12/2025.
//

import AppIntents

struct PauseIntent: AppIntent, LiveActivityIntent {
    // Metadata
    static var title: LocalizedStringResource { "Pause" }
    
    // Parameters
    
    // Perform
    func perform() async throws -> some IntentResult {
        TimerManager.shared.pause()
        return .result()
    }
}
