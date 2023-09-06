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
}

extension Feedback {
    public static func progress() {
        click.play()
    }

    public static func intermediate() {
        beep3.play()
    }

    public static func success() {
        beep4.play()
    }

    public static func error() {
        beepError.play()
    }
}

public struct Haptic {
    static let _copy = FeedbackGenerator(haptic: .heavy)
    static let _update = FeedbackGenerator(haptic: .heavy)
    
    static let _error = FeedbackGenerator(haptic: .error)
    static let _success = FeedbackGenerator(haptic: .success)
    static let _warning = FeedbackGenerator(haptic: .warning)
    
    static let _selection = FeedbackGenerator(haptic: .selection)
    
    static let _light = FeedbackGenerator(haptic: .light)
    static let _medium = FeedbackGenerator(haptic: .medium)
    static let _heavy = FeedbackGenerator(haptic: .heavy)
    
    public static func copy() { _copy.play() }
    public static func update() { _update.play() }
    
    public static func error() { _error.play() }
    public static func success() { _success.play() }
    public static func warning() { _warning.play() }
    
    public static func selection() { _selection.play() }
    
    public static func light() { _light.play() }
    public static func medium() { _medium.play() }
    public static func heavy() { _heavy.play() }
}
