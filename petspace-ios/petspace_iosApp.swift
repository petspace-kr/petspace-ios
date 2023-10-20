//
//  petspace_iosApp.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 10/14/23.
//

import SwiftUI
import CoreLocation

@main
struct petspace_iosApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MapAndStoreListView()
                .environment(StoreDatas())
            // ProfileView(isEditing: false)
        }
    }
}
