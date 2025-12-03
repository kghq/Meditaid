//
//  TimerView.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 01/12/2025.
//

import HealthKit
import SwiftUI

struct TimerView: View {
    
//    @State private var timerManager = TimerManager()
    
    @Environment(TimerManager.self) private var timerManager
    @Environment(Settings.self) private var settings
    
    @Environment(\.scenePhase) private var scenePhase
    @State private var autoHide: Task<Void, Never>? = nil // managing the hiding of status bar
    private let buttonHaptics = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        
        @Bindable var timerManager = timerManager
        
        VStack(spacing: 30) {
            ZStack {

                Spacer()
                
                TimelineView(.animation) { context in
                    Text(context.date, format: .timer(countingUpIn: timerManager.clock.timerCountingRange))
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
                        timerManager.hideStatusBarOnTap = false
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
                    timerManager.toggleSettings()
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
        .statusBarHidden(timerManager.statusBarHidden)
        .animation(.default, value: [timerManager.statusBarHidden, timerManager.clock.hasStarted, timerManager.clock.isRunning])
        .autoHideHomeIndicator(true)
        // Settings
        .sheet(isPresented: $timerManager.showingSettings) {
            SettingsView(settings: settings)
        }
//        .onChange(of: scenePhase) {
//            timerManager.settings.healthKitEnabled = timerManager.healthKitManager.checkAuthorization()
//        }
    }
    
    // Hiding StatusBar
    private func handleButtonHide() {
        timerManager.hideStatusBarOnTap = false
    }
    
    private func handleScreenTap() {
        
        autoHide?.cancel()
        
        if timerManager.clock.hasStarted {
            withAnimation(.default) {
                timerManager.hideStatusBarOnTap.toggle()
            }
            
            guard autoHide == nil else { return }
            
            autoHide = Task {
                do {
                    try await Task.sleep(for: .seconds(3))
                    
                    withAnimation(.default) {
                        timerManager.hideStatusBarOnTap.toggle()
                    }
                    
                    autoHide = nil
                } catch {
                    print(error.localizedDescription)
                    autoHide = nil
                }
            }
        } else {
            withAnimation(.default) {
                timerManager.hideStatusBarOnTap.toggle()
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
