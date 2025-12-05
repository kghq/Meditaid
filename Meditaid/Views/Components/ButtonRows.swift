//
//  ButtonRows.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 05/12/2025.
//

import SwiftUI

struct HourButtonRow: View {
	
	let timerManager: TimerManager
	@Binding var colors: [Color]
	
	var body: some View {
		HStack(spacing: 17) {
			ForEach(TimerButtonValue.hours) { value in
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
						.foregroundStyle(value.duration == timerManager.clock.timerDuration - timerManager.clock.minutes ? value.color : .white)
						.opacity(value.duration == timerManager.clock.timerDuration - timerManager.clock.minutes ? 1.0 : 0.7)
				}
			}
			.lineLimit(1)
			.minimumScaleFactor(0.5)
		}
	}
}

struct MinuteButtonRow: View {
	
	let timerManager: TimerManager
	@Binding var colors: [Color]
	
	var body: some View {
		HStack(spacing: 12) {
			ForEach(TimerButtonValue.minutes) { value in
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
						.foregroundStyle(value.duration == timerManager.clock.timerDuration - timerManager.clock.hours ? value.color : .white)
						.opacity(value.duration == timerManager.clock.timerDuration - timerManager.clock.hours ? 1.0 : 0.7)
				}
			}
			.lineLimit(1)
			.minimumScaleFactor(0.5)
		}
	}
}
