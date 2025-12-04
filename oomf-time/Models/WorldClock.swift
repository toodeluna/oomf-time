import Foundation

struct WorldClock: Identifiable, Codable {
  let id: UUID
  var emoji: String
  var label: String
  var timeZone: TimeZone

  init(id: UUID = UUID(), emoji: String, label: String, timeZone: TimeZone) {
    self.id = id
    self.emoji = emoji
    self.label = label
    self.timeZone = timeZone
  }
}
