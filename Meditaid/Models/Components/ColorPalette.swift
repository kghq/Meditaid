//
//  ColorPalette.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 05/12/2025.
//

import Foundation
import Observation
import SwiftUI

@Observable
class RingColors {
	 var colors: [Color]
	
//	var colors = [Color.red, Color.red, Color.red, Color.red]
	
	init() {
		var tempColors: [Color] = []
		for _ in 0..<5 {
			tempColors.append(TimerButtonValue.gradientColors.randomElement() ?? .red)
		}
		tempColors.append(tempColors[0])
		colors = tempColors
	}
}
