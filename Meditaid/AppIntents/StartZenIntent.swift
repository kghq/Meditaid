//
//  StartZenIntent.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 02/12/2025.
//

import AppIntents

struct StartZenIntent: AppIntent, LiveActivityIntent {
    // Metadata
    static var title: LocalizedStringResource { "Start" }

    // Parameters

    // Perform
    func perform() async throws -> some IntentResult {
        TimerManager.shared.start()
        return .result()
    }
}
