import SwiftUI

let onBreakTime = 5 * 60
let notOnBreakTime = 25 * 60

struct Countdown: View {
	let countdown: Int
	let onBreak: Bool

	var body: some View {
		VStack {
			Text(secondsToMinutesAndSeconds())
				.font(.system(size: 40))
		}
	}
	func secondsToMinutesAndSeconds() -> String {
		let minutes = countdown / 60
		let seconds = countdown % 60
		return String(format: "%02d:%02d", minutes, seconds)
	}
}

struct Progress: View {
	let countdown: Int
	let onBreak: Bool
	
	
	
	var body: some View {
		Circle()
			.fill(Color.clear)
			.frame(width: 270, height: 270)
			.overlay(
				Circle().trim(from: 0.0, to: min(currentProgress(), 1.0))
					.stroke(lineWidth: 15)
					.foregroundColor(
						(onBreak) ? (Color.green) : (Color.purple)
					)
			)
	}

	func currentProgress() -> CGFloat {
		let progress = (onBreak)
				? CGFloat(countdown) / CGFloat(onBreakTime)
				: CGFloat(countdown) / CGFloat(notOnBreakTime)
		return progress
	}
}

struct ContentView: View {
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

	@State var currentCountdown: Int = notOnBreakTime
	@State var currentOnBreak: Bool = false

	var body: some View {
		VStack {
			ZStack {
				Progress(countdown: currentCountdown, onBreak: currentOnBreak)
				Countdown(countdown: currentCountdown, onBreak: currentOnBreak)
			}
		}.onReceive(timer) { time in
			currentCountdown -= 1

			if(currentCountdown == 0) {
				if(currentOnBreak) {
					currentCountdown = notOnBreakTime
					currentOnBreak = false
				}
				else {
					currentCountdown = onBreakTime
					currentOnBreak = true
				}
			}
		}
	}
}

#Preview {
    ContentView()
}
