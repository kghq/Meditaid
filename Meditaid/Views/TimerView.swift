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
	@State private var showingCancelAlert = false
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
		
		VStack(spacing: 0) {
            ZStack {
                
				ZStack {
					Circle()
						.stroke(lineWidth: 6)
						.frame(minWidth: 280, minHeight: 280)
						.opacity(0.9)
					
					VStack {
						HourButtonRow(timerManager: timerManager)
						Spacer()
						MinuteButtonRow(timerManager: timerManager)
					}
					.font(.system(size: 30, weight: .medium, design: .default))
					.padding(.vertical, 70)
					.opacity(timerManager.clock.hasStarted ? 0.0 : 1.0)
					.animation(.default, value: timerManager.clock.isRunning)
				}
				.opacity(settings.mode == .timer ? 1.0 : 0.0)
				
                TimelineView(.animation) { context in
					ZStack {
						if settings.mode == .zen {
							Text(context.date, format: .timer(countingUpIn: timerManager.clock.zenCountingRange))
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
			.padding()
			.autoHideHomeIndicator(true)
			
			Rectangle()
				.frame(maxWidth: .infinity, maxHeight: 1)
				.foregroundStyle(.gray.opacity(timerManager.clock.hasStarted ? 0.0 : 0.25))
            
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
                    .foregroundStyle(timerManager.clock.hasStarted ? .red.opacity(timerManager.clock.isRunning ? 0.4 : 0.6) : .secondary)

                    Spacer()
                    
                    // Start / Pause
                    Button(timerManager.clock.isRunning ? "Pause" : (timerManager.clock.hasStarted ? "Resume" : "Start")) {
                        timerManager.clock.isRunning ? timerManager.pause() : timerManager.start()
                        buttonHaptics.impactOccurred()
                        autoHide?.cancel()
                        handleButtonHide()
                    }
					.foregroundStyle(timerManager.clock.hasStarted ? (timerManager.clock.isRunning ? .blue.opacity(0.4) : .green.opacity(0.6)) : .green.opacity(0.9))
                }
				.font(.title3)
				.bold()
                
                // Settings
				ZStack {
					Button("Settings") {
						toggleSettings()
					}
					.disabled(timerManager.clock.hasStarted)
					.font(.title3)
					.bold()
					.opacity(timerManager.clock.hasStarted ? 0.0 : 0.6)
					
					if settings.healthKitEnabled && timerManager.clock.hasStarted {
						Button("Cancel") { // show up when paused
							
							if settings.cancelWasTapped {
								timerManager.cancel()
								autoHide?.cancel()
								hideStatusBarOnTap = false
							} else {
								settings.cancelWasTapped = false
								showingCancelAlert = true
							}
						}
						.disabled(timerManager.clock.isRunning)
						.font(.title3)
						.bold()
						.foregroundStyle(.yellow.opacity(timerManager.clock.isRunning ? 0.0 : 0.6))
					}
				}
			}
			.padding()
			.frame(maxWidth: .infinity, maxHeight: 55)
			.background(.gray.opacity(timerManager.clock.hasStarted ? 0.0 : 0.1))
			.ignoresSafeArea()
        }
        .preferredColorScheme(.dark)
        .statusBarHidden(statusBarHidden)
        .animation(.default, value: [statusBarHidden, timerManager.clock.hasStarted, timerManager.clock.isRunning])
        // Settings
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
		.onAppear {
			// clock instance, change a color every 7 seconds ifRunning
		}
		.alert("Confirm Cancellation", isPresented: $showingCancelAlert) {
			Button("Cancel", role: .destructive) {
				timerManager.cancel()
				autoHide?.cancel()
				hideStatusBarOnTap = false
			}
			Button("Back", role: .cancel) { }
		} message: {
			Text("This will end the timer without logging Mindful Minutes.")
		}
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
		.environment(TimerManager(clock: ClockModel(), settings: Settings()))
        .environment(Settings())
}
