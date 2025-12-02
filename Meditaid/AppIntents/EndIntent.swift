//
//  EndIntent.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 02/12/2025.
//

import AppIntents

struct EndIntent: AppIntent, LiveActivityIntent {
    // Metadata
    static var title: LocalizedStringResource { "End" }
    
    // Parameters
    
    // Perform
    func perform() async throws -> some IntentResult {
        TimerManager.shared.end()
        return .result()
    }
}
