//
//  MeditaidApp.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 01/12/2025.
//

import SwiftUI

@main
struct MeditaidApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    @State private var timerManager: TimerManager
    @State private var settings: Settings
    
    var body: some Scene {
        WindowGroup {
            TimerView()
                .environment(timerManager)
                .environment(settings)
        }
        .onChange(of: scenePhase) {
            settings.healthKitEnabled = timerManager.healthKitManager.checkAuthorization()
        }
    }
    
    init() {
		
		_timerManager = State(initialValue: TimerManager(clock: ClockModel(mode: .timer)))
		_settings = State(initialValue: Settings())
		// TODO: change after debugging
//        do {
//			let clock: ClockModel = try LoadSave.load(from: "clock.json")
//			_timerManager = State(initialValue: TimerManager(clock: clock))
//			
//            let loadedSettings: Settings = try LoadSave.load(from: "settings.json")
//            _settings = State(initialValue: loadedSettings)
//        } catch {
//			_timerManager = State(initialValue: TimerManager(clock: ClockModel(mode: .zen)))
//            _settings = State(initialValue: Settings())
//            print("Error loading.")
//        }
    }
}
