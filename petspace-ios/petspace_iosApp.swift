//
//  petspace_iosApp.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/7/23.
//

import SwiftUI

@main
struct petspace_iosApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            // ControlView()
            ProfileTestView()
        }
    }
}
