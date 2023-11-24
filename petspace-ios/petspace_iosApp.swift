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
    // @ObservedObject var vm = MapViewModel()
    
    var body: some Scene {
        WindowGroup {
            ControlViewV2()
            // MapViewV2(storeViewModel: StoreViewModel(), mapViewModel: MapViewModel(), profileViewModel: ProfileViewModel())
        }
    }
}
