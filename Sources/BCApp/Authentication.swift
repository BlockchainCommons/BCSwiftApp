//
//  Authentication.swift
//  Gordian Seed Tool
//
//  Created by Wolf McNally on 1/16/21.
//

import LocalAuthentication
import SwiftUI
import Dispatch

public final class Authentication: ObservableObject {
    @Published var isUnlocked: Bool = false

    public func attemptUnlock(reason: String) {
        guard !isUnlocked else { return }
        
        #if targetEnvironment(simulator) || DEBUG
        
        self.isUnlocked = true
        
        #else

        let context = LAContext()

        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            //logger.error("Cannot authenticate: \(String(describing: error))")
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                guard success else {
                    //logger.error("Authentication failed: \(String(describing: error))")
                    return
                }
                
                self.isUnlocked = true
            }
        }
        
        #endif
    }
    
    public func lock() {
        guard isUnlocked else { return }
        self.isUnlocked = false
    }
}
