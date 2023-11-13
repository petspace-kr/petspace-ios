//
//  petspace_iosApp.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/7/23.
//

import SwiftUI

@main
struct petspace_iosApp: App {
    // Register App Delegate for Firebase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ControlView()
            // ProfileTestView()
        }
    }
}
