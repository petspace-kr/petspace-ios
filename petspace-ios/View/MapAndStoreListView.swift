//
//  MapAndStoreListView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 10/14/23.
//

import SwiftUI
import CoreLocation

struct MapAndStoreListView: View {
    
    @State var isWelcomeViewPresented: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                MapView(coordinate: CLLocationCoordinate2D(latitude: 37.489_902, longitude: 127.041_819))
                
                ButtonBarView()
                
                StoreListView()
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .onAppear() {
            if !UserDefaults.standard.bool(forKey: "hasShownWelcomeView") {
                isWelcomeViewPresented = true
                // UserDefaults.standard.set(true, forKey: "hasShownWelcomeView")
            }
        }
        .sheet(isPresented: $isWelcomeViewPresented, content: {
            WelcomeView()
        })
    }
}

#Preview {
    MapAndStoreListView()
}
