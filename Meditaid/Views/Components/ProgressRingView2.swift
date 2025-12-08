//
//  ProgressRingView2.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 08/12/2025.
//

import SwiftUI

struct ProgressRingView2: View {
	
	@State private var progress = 1.0
	@State private var isBreathing: Bool = false
	@State private var rotation = 0.0
	
	// Color
	var ringColors: [Color] // this has to be outside and observable
	
	// Initial bouncy ball values
	@State private var largeRadius: Double = 0.98
	
	var body: some View {
		GeometryReader { geometry in
			
			let size = min(geometry.size.width, geometry.size.height)
			
			ZStack {
				AngularGradient(colors: ringColors, center: .center)
					.rotationEffect(Angle(degrees: rotation))
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.animation(.linear(duration: 30).repeatForever(autoreverses: false), value: rotation)
					.mask(
						Circle()
							.rotation(Angle(degrees: -90))
							.trim(from: 0.0, to: 0.75)
							.stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
							.frame(maxWidth: largeRadius * size, maxHeight: largeRadius * size)
							// .animation(.linear, value: progress)
					)
					.animation(.easeInOut(duration: 6), value: ringColors)
			}
			.onAppear {
				rotation = 360.0
			}
		}
	}
}

#Preview {
	ProgressRingView2(ringColors: [.red, .blue, .green, .red])
}
