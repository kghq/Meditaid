//
//  TimerView.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 01/12/2025.
//

// import HealthKit
import Observation
import SwiftUI

struct TimerView: View {
    
    @Environment(TimerManager.self) private var timerManager
    @Environment(Settings.self) private var settings
    
    // Hiding Status Bar
    @State private var showingSettings = false
    @State private var hideStatusBarOnTap = false
    private var statusBarHidden: Bool {
        if timerManager.clock.hasStarted {
            return !hideStatusBarOnTap
        } else {
            return hideStatusBarOnTap
        }
    }
    
    @Environment(\.scenePhase) private var scenePhase
    @State private var autoHide: Task<Void, Never>? = nil // managing the hiding of status bar
    private let buttonHaptics = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
		
        VStack(spacing: 30) {
            ZStack {
                
				ZStack {
					
					Circle()
						.stroke(lineWidth: 6)
						.frame(minWidth: 280, minHeight: 280)
					
					VStack {
						HStack {
							Text("0h")
							Spacer()
							Text("1h")
							Spacer()
							Text("2h")
							Spacer()
							Text("3h")
							Spacer()
							Text("4h")
							Spacer()
							Text("5h")
						}
						Spacer()
						HStack {
							Text("05'")
							Spacer()
							Text("10'")
							Spacer()
							Text("15'")
							Spacer()
							Text("20'")
							Spacer()
							Text("30'")
							Spacer()
							Text("45'")
						}
					}
					.monospacedDigit()
					.font(.system(size: 30, weight: .semibold))
					.padding(.vertical, 40)
					.opacity(timerManager.clock.hasStarted ? 0.0 : 1.0)
					.animation(.default, value: timerManager.clock.isRunning)
				}
				.opacity(settings.mode == .timer ? 0.9 : 0.0)
				.padding()
				
                TimelineView(.animation) { context in
					ZStack {
						if settings.mode == .zen {
							Text(context.date, format: .timer(countingUpIn: timerManager.clock.timerCountingRange))
						} else {
							Text(context.date, format: .timer(countingDownIn: timerManager.clock.timerCountingRange))
						}
					}
					.monospacedDigit()
					.font(.system(size: 60, weight: .medium))
                }
				
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color.clear
                    .contentShape(Rectangle())
            )
            .onTapGesture {
                handleScreenTap()
            }
            
            // Buttons
            ZStack {
                HStack {
                    
                    // End
                    Button("End") {
                        timerManager.end()
                        buttonHaptics.impactOccurred()
                        autoHide?.cancel()
                        hideStatusBarOnTap = false
                    }
                    .disabled(!timerManager.clock.hasStarted)
                    .font(.title3)
                    .bold()
                    .foregroundStyle(timerManager.clock.hasStarted ? .red.opacity(timerManager.clock.isRunning ? 0.7 : 0.8) : .secondary)
                    .padding()
    //                Button("Reset") {
    //                    timerManager.reset()
    //                    buttonHaptics.impactOccurred()
    //                    autoHide?.cancel()
    //                    hideStatusBarOnTap = false
    //                }

                    Spacer()
                    
                    // Start / Pause
                    Button(timerManager.clock.isRunning ? "Pause" : (timerManager.clock.hasStarted ? "Resume" : "Start")) {
                        timerManager.clock.isRunning ? timerManager.pause() : timerManager.start()
                        buttonHaptics.impactOccurred()
                        autoHide?.cancel()
                        handleButtonHide()
                    }
                    .font(.title3)
                    .bold()
                    .foregroundStyle(timerManager.clock.hasStarted ? .blue.opacity(timerManager.clock.isRunning ? 0.7 : 0.8) : .green.opacity(0.9))
                    .padding()
                }
                
                // Settings
                Button("Settings") {
                    toggleSettings()
                }
                .disabled(timerManager.clock.hasStarted)
                .font(.title3)
                .bold()
                .opacity(timerManager.clock.hasStarted ? 0.0 : 0.7)
                .padding()
            }
        }
        .padding()
        .preferredColorScheme(.dark)
        .statusBarHidden(statusBarHidden)
        .animation(.default, value: [statusBarHidden, timerManager.clock.hasStarted, timerManager.clock.isRunning])
        .autoHideHomeIndicator(true)
        // Settings
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
		.onAppear {
			// clock instance, change a color every 7 seconds ifRunning
		}
//        .onChange(of: scenePhase) {
//            timerManager.settings.healthKitEnabled = timerManager.healthKitManager.checkAuthorization()
//        }
    }
    
    // Toggle Settings
    private func toggleSettings() {
        showingSettings.toggle()
        hideStatusBarOnTap = false
    }
    
    // Hiding StatusBar
    private func handleButtonHide() {
        hideStatusBarOnTap = false
    }
    
    private func handleScreenTap() {
        
        autoHide?.cancel()
        
        if timerManager.clock.hasStarted {
            withAnimation(.default) {
                hideStatusBarOnTap.toggle()
            }
            
            guard autoHide == nil else { return }
            
            autoHide = Task {
                do {
                    try await Task.sleep(for: .seconds(3))
                    
                    withAnimation(.default) {
                        hideStatusBarOnTap.toggle()
                    }
                    
                    autoHide = nil
                } catch {
                    print(error.localizedDescription)
                    autoHide = nil
                }
            }
        } else {
            withAnimation(.default) {
                hideStatusBarOnTap.toggle()
            }
        }
    }
}

#Preview {
    TimerView()
		.environment(TimerManager(clock: ClockModel(mode: .timer)))
        .environment(Settings())
}

// Interval haptics and sounds
//            .onChange(of: model.elapsed) { oldValue, newValue in
//                let seconds = newValue.components.seconds
//                if let intervalDuration = settings.intervalDuration {
//                    if seconds % intervalDuration.components.seconds == 0 && seconds != 0 {
//                        UIImpactFeedbackGenerator(style: .medium).impactOccurred(intensity: 0.4)
//                    }
//                }
//            }

//Text(context.date, format: .timer(countingUpIn: (timerManager.isRunning ?
//    (timerManager.controlDate + timerManager.compoundedRuns) : (Date.now + timerManager.compoundedRuns))..<Date.distantFuture
//))
