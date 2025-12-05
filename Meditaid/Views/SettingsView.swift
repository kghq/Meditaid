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
//enum Route: Hashable {
//    case soundsAndHaptics
//}

struct SettingsView: View {
    
	@Environment(Settings.self) var settings
    @Environment(\.dismiss) var dismiss
    // @State private var path = NavigationPath()
    
    var healthKitManager = HealthKitManager()
    
    var body: some View {
		
		@Bindable var settings = settings
		
        NavigationStack {
			
			// Picker
			Picker("Mode", selection: $settings.mode) {
				ForEach(Mode.allCases) { mode in
					Text(mode.rawValue)
						.tag(mode)
				}
			}
			.pickerStyle(.palette)
			.padding([.horizontal, .top])
			
			// List
            List {
                
				Section {
					VStack(alignment: .leading) {
						if settings.mode == .zen {
							ZStack {
								RoundedRectangle(cornerRadius: 10)
									.foregroundStyle(.gray)
								Image(systemName: "figure.mind.and.body")
									.font(.system(size: 30))
							}
							.frame(width: 50, height: 50)
							Text("Zen")
								.font(.system(size: 30, weight: .bold))
								.fontWeight(.semibold)
							Text("This mode only measures time, and logs Mindful Minutes to Apple Health, if you choose so.")
								.padding(.top, 1)
						} else {
							ZStack {
								RoundedRectangle(cornerRadius: 10)
									.foregroundStyle(.gray)
								Image(systemName: "stopwatch")
									.font(.system(size: 30))
							}
							.frame(width: 50, height: 50)
							Text("Timer")
								.font(.system(size: 30, weight: .bold))
							Text("Countdown timer will notify you when your session ends, or end silently, if you do that in settings.")
								.padding(.top, 3)
						}
					}
				}
				
				if settings.mode == .timer {
					Section {
						NavigationLink("Sounds & Haptics") {
							SoundsAndHapticsView(dismiss: dismiss)
						}
					}
				}
				
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
			.animation(.default, value: settings.mode)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline) // then "Settings" title
//          .navigationDestination(for: Route.self) { route in
//                switch route {
//                default:
//                    SoundsAndHapticsView()
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
    SettingsView()
        .preferredColorScheme(.dark)
		.environment(Settings())
}
