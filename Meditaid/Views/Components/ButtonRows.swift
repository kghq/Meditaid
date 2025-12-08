//
//  ButtonRows.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 05/12/2025.
//

import SwiftUI

struct HourButtonRow: View {
	
	@State private var timerButtons = TimerButtons()
	let timerManager: TimerManager
	@Binding var colors: [Color]
	private let buttonHaptics = UIImpactFeedbackGenerator(style: .light)
	
	var body: some View {
		HStack(spacing: 10) {
			ForEach(timerButtons.hours) { value in
				Button {
					
					timerManager.clock.hours = value.duration
					
					let randomPosition = Int.random(in: 0..<colors.count)
					if randomPosition == 0 || randomPosition == colors.count - 1 {
						colors[0] = value.color
						colors[colors.count - 1] = value.color
					} else {
						colors[randomPosition] = value.color
					}
				} label: {
					Text(value.label)
						.foregroundStyle(value.duration == timerManager.clock.timerDuration - timerManager.clock.minutes ? value.color : .primary)
						.fontWeight(value.duration == timerManager.clock.timerDuration - timerManager.clock.minutes ? .semibold : .regular)
						.opacity(value.duration == timerManager.clock.timerDuration - timerManager.clock.minutes ? 1.0 : 0.4)
						.scaleEffect(value.duration == timerManager.clock.timerDuration - timerManager.clock.minutes ? 1.0 : 0.8)
				}
				.disabled(value.duration == 0 && timerManager.clock.minutes == 0)
			}
			.lineLimit(1)
			.minimumScaleFactor(0.5)
		}
	}
}

struct MinuteButtonRow: View {
	
	@State private var timerButtons = TimerButtons()
	let timerManager: TimerManager
	@Binding var colors: [Color]
	private let buttonHaptics = UIImpactFeedbackGenerator(style: .light)
	
	var body: some View {
		HStack(spacing: 7) {
			ForEach(timerButtons.minutes) { value in
				Button {
					
					timerManager.clock.minutes = value.duration
					
					let randomPosition = Int.random(in: 0..<colors.count)
					if randomPosition == 0 || randomPosition == colors.count - 1 {
						colors[0] = value.color
						colors[colors.count - 1] = value.color
					} else {
						colors[randomPosition] = value.color
					}
				} label: {
					Text(value.label)
						.foregroundStyle(value.duration == timerManager.clock.timerDuration - timerManager.clock.hours ? value.color : .primary)
						.fontWeight(value.duration == timerManager.clock.timerDuration - timerManager.clock.hours ? .semibold : .regular)
						.opacity(value.duration == timerManager.clock.timerDuration - timerManager.clock.hours ? 1.0 : 0.4)
						.scaleEffect(value.duration == timerManager.clock.timerDuration - timerManager.clock.hours ? 1.0 : 0.8)
				}
				.disabled(value.duration == 0 && timerManager.clock.hours == 0)
			}
			.lineLimit(1)
			.minimumScaleFactor(0.5)
		}
	}
}
