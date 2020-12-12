import Foundation
import SwiftUI

extension TimeInterval {

  func format() -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.day, .hour, .minute, .second]
    formatter.unitsStyle = .short
    formatter.maximumUnitCount = 1
    return formatter.string(from: self) ?? ""
  }
}
