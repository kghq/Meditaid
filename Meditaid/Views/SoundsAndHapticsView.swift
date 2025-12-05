//
//  SoundsAndHapticsView.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 04/12/2025.
//

import SwiftUI

struct SoundsAndHapticsView: View {
	
	@Environment(Settings.self) var settings
	let dismiss: DismissAction
	
	@State private var hapticsOn = false
	@State private var alarmOn = false
	
    var body: some View {
		
		@Bindable var settings = settings
		
		Form {
			Section {
				Toggle("Haptics", isOn: $hapticsOn)
				Toggle("Alarm", isOn: $alarmOn)
			} header: {
				Text("Get notified when session ends")
			}
		}
		.navigationTitle("Sounds & Haptics")
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button("Done") {
					dismiss()
				}
			}
		}
    }
}

#Preview {
	@Previewable @Environment(\.dismiss) var dismiss
	SoundsAndHapticsView(dismiss: dismiss)
		.environment(Settings())
		.preferredColorScheme(.dark)
}
