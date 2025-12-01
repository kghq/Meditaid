//
//  SettingsView.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 01/12/2025.
//

import HealthKit
import SwiftData
import SwiftUI

// Navigation
enum Route: Hashable {
    case soundsAndHaptics
}

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var path = NavigationPath()
    
    @Bindable var settings: Settings
    
    var healthKitManager = HealthKitManager()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                // Choose Mode
//                settings.mode == .zen ? Text("Zen Mode") : Text("Timer Mode")
//                Section {
//                    NavigationLink(value: Route.soundsAndHaptics) {
//                        Text("Sounds and Haptics")
//                    }
//                } header: {
//
//                }
                    
                // HealthKit
                Section {
                    HStack {
                        Toggle(isOn: $settings.healthKitEnabled) {
                            Text("Log To Apple Health")
                        }
                        .onChange(of: settings.healthKitEnabled) { _, newValue in
                            settings.healthKitToggleTapCounter += 1
                            if newValue {
                                healthKitManager.requestAuthorization { success, error in
                                    DispatchQueue.main.async {
                                        if success && healthKitManager.checkAuthorization() {
                                        } else {
                                            self.settings.healthKitEnabled = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                } footer: {
                    if settings.healthKitToggleTapCounter <= 1 {
                        
                    } else {
                        if healthKitManager.checkAuthorization() {
                            
                        } else {
                            Text("It appears you have revoked Meditaid’s permission to log Mindful Minutes to Apple Health. To grant permission again, go to Health App -> Browse -> Mental Wellbeing -> Mindful Minutes -> [Scroll Down] -> Data Sources & Access -> Tap Edit -> Checkmark Meditaid -> Tap Done.")
                        }
                    }
                }
            }
            .navigationTitle("Meditaid")
            // .navigationBarTitleDisplayMode(.inline) // then "Settings" title
//            .navigationDestination(for: Route.self) { route in
//                switch route {
//                default:
//                    // SoundsAndHaptics(settings: settings)
//                }
//            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView(settings: Settings())
        .preferredColorScheme(.dark)
}
