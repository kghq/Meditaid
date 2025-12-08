//
//  ButtonValues.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 04/12/2025.
//

import SwiftUI

struct TimerButtonValue: Identifiable {
	
	let id = UUID()
	
	static let gradientColors: [Color] = [
		Color.red,
		Color.yellow,
		Color.green,
		Color.blue,
		Color.cyan,
		Color.indigo,
		Color.orange,
		Color.purple
	]
	
	let label: String
	let duration: TimeInterval
	let color: Color
	var scale: Double = 0.8
	// later var timerColor: RGBColor = RGBColor(red: 1.0, green: 0.0, blue: 0.0)
	
	static let minutes: [TimerButtonValue] = [
		TimerButtonValue(label: "0'", duration: 0, color: .red),
		TimerButtonValue(label: "5'", duration: 5 * 60, color: .red),
		TimerButtonValue(label: "10'", duration: 10 * 60, color: .yellow),
		TimerButtonValue(label: "15'", duration: 15 * 60, color: .orange),
		TimerButtonValue(label: "20'", duration: 20 * 60, color: .green),
		TimerButtonValue(label: "30'", duration: 30 * 60, color: .blue),
		TimerButtonValue(label: "45'", duration: 45 * 60, color: .cyan)
	]
	
	static let hours: [TimerButtonValue] = [
		TimerButtonValue(label: "0h", duration: 0, color: .indigo),
		TimerButtonValue(label: "1h", duration: 3600, color: .purple),
		TimerButtonValue(label: "2h", duration: 2 * 3600, color: .orange),
		TimerButtonValue(label: "3h", duration: 3 * 3600, color: .green),
		TimerButtonValue(label: "4h", duration: 4 * 3600, color: .blue),
		TimerButtonValue(label: "5h", duration: 5 * 3600, color: .cyan),
		TimerButtonValue(label: "6h", duration: 6 * 3600, color: .cyan)
	]
}
