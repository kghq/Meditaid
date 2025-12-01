//
//  TimerView.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 01/12/2025.
//

import HealthKit
import SwiftUI

struct TimerView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var timerManager = TimerManager()

    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                
                Spacer()
                
                TimelineView(.periodic(from: timerManager.controlDate, by: 1.0)) { context in
                    Text(context.date, format: .timer(countingUpIn: timerManager.timerCountingRange))
                        .monospacedDigit()
                        .font(.system(size: 60, weight: .medium))
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color.clear
                    .contentShape(Rectangle())
            )
            .onTapGesture {
                timerManager.handleScreenTap()
            }
            
            // Buttons
            ControlButtons(timerManager: $timerManager)
        }
        .padding()
        .preferredColorScheme(.dark)
        .statusBarHidden(timerManager.isStatusBarHidden)
        .animation(.default, value: [timerManager.isStatusBarHidden, timerManager.hasStarted, timerManager.isRunning])
        .autoHideHomeIndicator(true)
        // Settings
        .sheet(isPresented: $timerManager.showingSettings) {
            SettingsView(settings: timerManager.settings)
        }
        .onChange(of: scenePhase) {
            timerManager.settings.healthKitEnabled = timerManager.healthKitManager.checkAuthorization()
        }
    }
}

struct ControlButtons: View {
    
    @Binding var timerManager: TimerManager
    
    var body: some View {
        ZStack {
            HStack {
                
                // End
                Button("End") {
                    timerManager.end()
                }
                .disabled(!timerManager.hasStarted)
                .font(.title3)
                .bold()
                .foregroundStyle(timerManager.hasStarted ? .red.opacity(timerManager.isRunning ? 0.7 : 0.8) : .secondary)
                .padding()

                Spacer()
                
                // Start / Pause
                Button(timerManager.isRunning ? "Pause" : (timerManager.hasStarted ? "Resume" : "Start")) {
                    timerManager.isRunning ? timerManager.pause() : timerManager.start()
                }
                .font(.title3)
                .bold()
                .foregroundStyle(timerManager.hasStarted ? .blue.opacity(timerManager.isRunning ? 0.7 : 0.8) : .green.opacity(0.9))
                .padding()
            }
            
            // Settings
            Button("Settings") {
                timerManager.toggleSettings()
            }
            .disabled(timerManager.hasStarted)
            .font(.title3)
            .bold()
            .opacity(timerManager.hasStarted ? 0.0 : 0.7)
            .padding()
        }
    }
}

#Preview {
    TimerView()
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
