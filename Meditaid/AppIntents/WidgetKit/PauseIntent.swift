//
//  PauseAppIntent.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 02/12/2025.
//

//import AppIntents
//
//struct PauseIntent: AppIntent, LiveActivityIntent {
//    // Metadata
//    static var title: LocalizedStringResource { "Pause" }
//    
//    // Parameters
//    
//    static var parameterSummary: some ParameterSummary {
//        Summary("Pause The Session")
//    }
//    
//    // Perform
//    @MainActor
//    func perform() async throws -> some IntentResult {
//        TimerManager.shared.pause()
//        return .result()
//    }
//}
