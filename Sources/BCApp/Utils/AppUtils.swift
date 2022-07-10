import Foundation
import UIKit
import SwiftUI
import os

public struct Application {
    public static let maxFragmentLen = 600

    public static let bundleIdentifier = Bundle.main.bundleIdentifier!

    public static let isTakingSnapshot = ProcessInfo.processInfo.arguments.contains("SNAPSHOT")

    public static let version: String = {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }()
    
    public static let buildNumber: String = {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }()
    
    public static let appDisplayName: String = {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    }()

    public static let fullVersion: String = {
        "\(version) (\(buildNumber))"
    }()
    
    public static let isAppSandbox: Bool = {
        Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    }()
    
    public static let isDebug: Bool = {
    #if DEBUG
        true
    #else
        false
    #endif
    }()
    
    public static let isSimulator: Bool = {
    #if targetEnvironment(simulator)
        true
    #else
        false
    #endif
    }()
    
    public static let isCatalyst: Bool = {
    #if targetEnvironment(macCatalyst)
        true
    #else
        false
    #endif
    }()
    
    public static let isAPNSSandbox: Bool = {
        #if targetEnvironment(macCatalyst)
        var p = URL(fileURLWithPath: Bundle.main.bundlePath)
        p.appendPathComponent("Contents", isDirectory: true)
        p.appendPathComponent("embedded.provisionprofile")
        let filePath = p.path
        #else
        guard let filePath = Bundle.main.path(forResource: "embedded", ofType:"mobileprovision") else {
            return false
        }
        #endif
        do {
            let url = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: url)
            guard let string = String(data: data, encoding: .ascii) else {
                return false
            }
            if string.contains("<key>aps-environment</key>\n\t\t<string>development</string>") {
                return true
            }
        } catch {
            Logger().log("⛔️ \(error.localizedDescription)")
        }
        return false
    }()
}
