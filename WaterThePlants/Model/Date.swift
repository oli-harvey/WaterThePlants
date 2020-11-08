import Foundation
import SwiftUI

extension Date {
    
    func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
    func timeString() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    func dateTimeString() -> String {
        if Date().dateString() == self.dateString() {
            return self.dateString()
        } else {
            return self.timeString()
        }
    }
}

