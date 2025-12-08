//
//  TimerButtons.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 08/12/2025.
//

import SwiftUI

struct TimerButtons {
	
	var scale = 1.0
	
	var minutes: [TimerButtonValue] = [
		TimerButtonValue(label: "5'", duration: 5 * 60, color: .red),
		TimerButtonValue(label: "10'", duration: 10 * 60, color: .yellow),
		TimerButtonValue(label: "15'", duration: 15 * 60, color: .orange),
		TimerButtonValue(label: "20'", duration: 20 * 60, color: .green),
		TimerButtonValue(label: "30'", duration: 30 * 60, color: .blue),
		TimerButtonValue(label: "45'", duration: 45 * 60, color: .cyan)
	]
	
	var hours: [TimerButtonValue] = [
		TimerButtonValue(label: "0h", duration: 0, color: .indigo),
		TimerButtonValue(label: "1h", duration: 3600, color: .purple),
		TimerButtonValue(label: "2h", duration: 2 * 3600, color: .orange),
		TimerButtonValue(label: "3h", duration: 3 * 3600, color: .green),
		TimerButtonValue(label: "4h", duration: 4 * 3600, color: .blue),
		TimerButtonValue(label: "5h", duration: 5 * 3600, color: .cyan)
	]
}
