import CoreData
import Foundation
import SwiftUI

@objc(Task)
public class Task: NSManagedObject {
    deinit {
        cancelNotification()
    }
    var beingEditted = false
    var animationCoolDown = false
    var shakeLeft = false
}
