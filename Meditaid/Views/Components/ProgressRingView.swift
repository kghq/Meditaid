//
//  ProgressRingView.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 05/12/2025.
//

import SwiftUI

struct ProgressRingView: View {
	
	@State private var progress = 1.0
	@State private var isBreathing: Bool = false
	@State private var rotation = 0.0
	
	// Color
	var ringColors: [Color] // this has to be outside and observable
	
	// Initial bouncy ball values
	@State private var largeRadius: Double = 1
	@State private var smallRadius: Double = 0.96
	
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
							.trim(from: 0.0, to: progress)
							.stroke(style: StrokeStyle(lineWidth: 100, lineCap: .butt))
							.animation(.linear(duration: 450), value: progress)
							.mask(
								ZStack {
									Circle()
										.frame(width: largeRadius * size, height: largeRadius * size)
									Circle()
										.frame(width: smallRadius * size, height: smallRadius * size)
										.blendMode(.destinationOut)
								}
									.compositingGroup()
									.frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .center)
									.onAppear {
										largeRadius = 0.93
										smallRadius = 0.87
									}
									.animation(.easeInOut(duration: 7).repeatForever(), value: largeRadius)
							)
					)
					.animation(.easeInOut(duration: 6), value: ringColors)
			}
			.onAppear {
				rotation = 360.0
			}
		}
    }
	
//	init() {
//		var tempColors: [Color] = []
//		for _ in 0..<5 {
//			tempColors.append(gradientColors.randomElement() ?? .red)
//		}
//		tempColors.append(tempColors[0])
//		ringColors = tempColors
//	}
}

#Preview {
	ProgressRingView(ringColors: [.red, .blue, .green])
}
	
	//    mutating func changeColors() {
	//        task = Task {
	//            while !Task.isCancelled {
	//                try? await Task.sleep(nanoseconds: 1_000_000_000)
	//
	//                let selectedPosition = Int.random(in: 0..<angularColors.count)
	//                let randomColor = gradientColors.randomElement() ?? .red
	//                if selectedPosition == 0 || selectedPosition == angularColors.count - 1 {
	//                    angularColors[0] = randomColor
	//                    angularColors[angularColors.count - 1] = randomColor
	//                } else {
	//                    angularColors[selectedPosition] = randomColor
	//                }
	//            }
	//        }
	//    }
