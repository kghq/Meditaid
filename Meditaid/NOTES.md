# NOTES

## Timer
When this mode on, a progress bar below the timer always visible (even when not running)
A grid of 0: hours options and :15 minutes options. Option pressed has some color. Same font as clock.
Gradient circle progress bar.
All has slightly reduced opacity.
When timer starts, all disappears besides the clock and progress bar.
Notification at the end, or AlarmKit, then? Does it support a single chime and a tap instead of continuous alarm and vibrating?
Live Activity Notifications instead of regular system notifications?
Alwasy reverts back to the last duration user set. After another launch, after changing back to the mode, after finishing the countdown.
In Live activity, a circular progress bar, in minimal, this instead of minutes
### Just to learn, not in the final version
Implement Haptics and Sounds to intervals (this belongs in Apple Watch)
Let user choose between haptics and/or sounds (this belongs in Apple Watch)

## When Timer is done
Long-press app icon: options for Zen, 10, 30 minutes.
### Live Activities
Progress circle in minimal
Rearrange with progress bar in expanded and Lock screen

## Apple Watch
Haptics intervals
Orange/black animation
Orange rises up from bottom as timer goes on. Timer font changes color from white to black.
Two modes as two swipeable screens with a third of settings?
Complications

## App Icon

## Other Features
Glass font for timer and buttons
Green tint for glass
Accessibility (actually should be quite easy in such a simple app. Consult HWS.)
Localization
Onboarding
Reminders: fire off only if no meditation logged that day.
App Store
Link to me. Maybe link to sounds, if using custom in settings.
StandBy
Configure widget stacks if necessary

## App Intents
Action Button: start a 5 minute meditation (or any length user set in a shortcut). Or start a zen mode. I can even provide shortcut files on my webpage.
Advanced Siri support (and App Intents)
siri, stop this timer (Making onscreen content available to Siri and Apple Intelligence)
Spotlight
Control center icon and lock screen
Lock Screen widgets (the ones under the clock, like Weather or Home)
Focus
### Shortcuts
Start Zen mode
Start a timer
pause a timer
pause zen mode
End a timer
End zen mode
take 5
Start a timer at custom length
### Live Activities
App Intents needed
LA Expanded: kiedy zegarek leci, tylko przycisk pause. Kiedy Pause, Pause zamienia się w Play (resume) i pojawia się przycisk X (End)
Time elapsed + controls: "pause/play" and "end session" buttons
### Widgets
Starts a meditation
Starts a timer (length to choose from widget settings)
Maybe something like "take a 5" or something? Just 5 minute timer, no settings, and a different button?

## Icons
Meditation
meditation.apple
person.bust
shareplay
figure.yoga
figure.mind.and.body
gear
gearshape2

## Every app shpuld have
Widgets: Live activities, widgets per se
App intents: spotlight suggestions, Siri integration, Shortcuts and Actions (with Action Button)
Lock screen widgets and button for Control Center
Good Haptics
Good Animations
Be in line with HIG
Good Icon
Accessibility
Notifications
Long press app icon and menu
Watch support

## Code for later
### App Intents
    // protocols and types: String, AppEnum
    
//    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Mode"
    
//    static var caseDisplayRepresentations: [Mode: DisplayRepresentation] = [
//        .zen: DisplayRepresentation(title: "Zen", image: .init(systemName: "figure.mind.and.body")),
//        .timer: DisplayRepresentation(title: "Timer", image: .init(systemName: "stopwatch"))
//    ]

// TODO: - Live Activity Interactive Buttons
//struct LockScreenActivityButton: View {
//
//    let type: String
//    var isRunning: Bool = true
//
//    var body: some View {
//        VStack {
//            Button(intent: PauseTimerIntent()) {
//                Label("End", systemImage: "stop.fill")
//                    .font(.caption)
//                    .labelsHidden()
//            }
//            .tint(.red)
//            .disabled(isRunning)
//            .frame(maxWidth: .infinity)
//            Button(intent: PauseTimerIntent()) {
//                Label("Pause", systemImage: "pause")
//                    .font(.caption)
//                    .labelsHidden()
//            }
//            .tint(.blue)
//            .frame(maxWidth: .infinity)
//        }
//        .frame(width: 100)
//    }
//}


## Animation
Let's leave it to the end, and first implement UI and features. Animation is the least useful here.
Wheel rotating at a given cadence: for example, a visulal queue every 15 minutes is one rotation, visible at a glance, how much of 15 minutes elapsed.
Or a breathing ring that contracts and expands.
Timing of a contracting circle: 5.5 x 5.5 x 5.5
Breathing circle with one over it, in color of background, indicating time passed


    func endOldActivities() {
        guard let currentActivityID = self.activity?.id else {
            // endAllActivities()
            return
        }
        
        Task {
            let allActivities = Activity<TimerAttributes>.activities
            for activity in allActivities {
                if activity.id != currentActivityID {
                    let finalState = TimerAttributes.ContentState(
                        startDate: Date.distantPast,
                        pauses: [],
                        isRunning: false
                    )
                    await activity.end(ActivityContent(state: finalState, staleDate: nil), dismissalPolicy: .immediate)
                }
            }
        }
    }
