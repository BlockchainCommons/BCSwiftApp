import Foundation
import URUI

public struct Feedback {
    public static let beep1 = FeedbackGenerator(haptic: .heavy, soundFile: "beep1.mp3", subdirectory: "Sounds")
    public static let beep2 = FeedbackGenerator(haptic: .heavy, soundFile: "beep2.mp3", subdirectory: "Sounds")
    public static let beep3 = FeedbackGenerator(haptic: .heavy, soundFile: "beep3.mp3", subdirectory: "Sounds")
    public static let beep4 = FeedbackGenerator(haptic: .success, soundFile: "beep4.mp3", subdirectory: "Sounds")
    public static let beepError = FeedbackGenerator(haptic: .error, soundFile: "beepError.mp3", subdirectory: "Sounds")
    public static let click = FeedbackGenerator(haptic: .light, soundFile: "click.caf", subdirectory: "Sounds")

    public static let unlock = FeedbackGenerator(haptic: .medium, soundFile: "unlock.mp3", subdirectory: "Sounds")
    public static let lock = FeedbackGenerator(haptic: .medium, soundFile: "lock.mp3", subdirectory: "Sounds")
    
    public static let copy = FeedbackGenerator(haptic: .heavy)
    public static let update = FeedbackGenerator(haptic: .heavy)
}

extension Feedback {
    public static func progress() {
        click.play()
    }

    public static func success() {
        beep4.play()
    }

    public static func error() {
        beepError.play()
    }
}
