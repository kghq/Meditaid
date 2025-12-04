//
//  TimerView.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 01/12/2025.
//

import HealthKit
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
        
        @Bindable var timerManager = timerManager
        
        VStack(spacing: 30) {
            ZStack {
                
				VStack {
					Spacer()
					Text("0:    1:    2:    3:    4:    5:")
					Spacer()
					// Text("3: 4: 5:")
					Circle()
						.stroke(lineWidth: 6)
						.frame(minWidth: 280, minHeight: 280)
					Spacer()
					Text(":5  :10  :15  :20  :30  :45")
					// Text(":20 :30 :45")
					Spacer()
				}
				.padding(.horizontal)
				.monospacedDigit()
				.font(.system(size: 30, weight: .medium)) // adaptive size?
				
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
            SettingsView(settings: settings)
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
        .environment(TimerManager())
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
