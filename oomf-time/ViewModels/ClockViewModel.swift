import Combine
import Foundation

class ClockViewModel: ObservableObject {
  @Published var clocks: [WorldClock] = []
  @Published var showAddClock = false
  @Published var timeOffset: Double = 0
  @Published var fontSize: CGFloat = 14

  private let defaults = UserDefaults.standard
  private let clocksKey = "savedClocks"

  init() {
    loadClocks()
  }

  func addClock(emoji: String, label: String, timeZone: TimeZone) {
    let clock = WorldClock(emoji: emoji, label: label, timeZone: timeZone)
    clocks.append(clock)
    saveClocks()
  }

  func deleteClock(_ clock: WorldClock) {
    clocks.removeAll { $0.id == clock.id }
    saveClocks()
  }

  private func saveClocks() {
    if let encoded = try? JSONEncoder().encode(clocks) {
      defaults.set(encoded, forKey: clocksKey)
    }
  }

  private func loadClocks() {
    if let data = defaults.data(forKey: clocksKey),
      let decoded = try? JSONDecoder().decode([WorldClock].self, from: data)
    {
      clocks = decoded
    }
  }
}
