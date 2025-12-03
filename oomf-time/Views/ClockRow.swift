import SwiftUI
import Combine

struct ClockRow: View {
    let clock: WorldClock
    let timeOffset: Double
    let fontSize: CGFloat
    @ObservedObject var viewModel: ClockViewModel
    
    @State private var currentTime = Date()
    @State private var isHovering = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 12) {
            Text(clock.emoji)
                .font(.system(size: fontSize * 2))
                .frame(width: 40)
            
            Text(clock.label)
                .font(.system(size: fontSize, weight: .medium))
            
            Spacer()
            
            Text(timeString)
                .font(.system(size: fontSize + 4, weight: .semibold, design: .rounded))
                .monospacedDigit()
            
            if isHovering {
                Button(action: {
                    viewModel.deleteClock(clock)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
            }
            
        }
        .padding()
        .contentShape(Rectangle())
        .onHover { hovering in
            isHovering = hovering
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }
    
    private var adjustedTime: Date {
        currentTime.addingTimeInterval(timeOffset * 3600)
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeZone = clock.timeZone
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: adjustedTime)
    }
}
