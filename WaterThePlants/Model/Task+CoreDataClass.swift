import CoreData
import Foundation
import SwiftUI

@objc(Task)
public class Task: NSManagedObject {
    deinit {
        cancelNotification()
    }
}
