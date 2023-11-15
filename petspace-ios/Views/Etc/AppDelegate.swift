//
//  AppDelegate.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/13/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // ADHOC 배포 시
        // https://stackoverflow.com/questions/43754848/how-to-debug-firebase-on-ios-adhoc-build/47594030#47594030
        #if DEBUG
        var newArguments = ProcessInfo.processInfo.arguments
        newArguments.append("-FIRDebugEnabled")
        ProcessInfo.processInfo.setValue(newArguments, forKey: "arguments")
        #endif
        
        FirebaseApp.configure()
        return true
    }
}

/*
let event = ""
let params = [
    "file": file as NSObject,
    "function": function as NSObject
]
 
Analytics.setUserID("userID = \(1234)")
Analytics.setUserProperty("ko", forName: "country")
Analytics.logEvent(AnalyticsEventSelectItem, parameters: nil) // select_item으로 로깅
Analytics.logEvent(event, parameters: parameters)
 
Analytics.setDefaultEventParameters([
    "level_name": "Caverns01",
    "level_difficulty": 4
])
 */
