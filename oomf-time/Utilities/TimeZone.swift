import Foundation

extension TimeZone: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let identifier = try container.decode(String.self)
    guard let timeZone = TimeZone(identifier: identifier) else {
      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: "Invalid time zone identifier"
      )
    }
    self = timeZone
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(identifier)
  }
}
