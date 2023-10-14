//
//  MapAndStoreListView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 10/14/23.
//

import SwiftUI
import CoreLocation

struct MapAndStoreListView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                MapView(coordinate: CLLocationCoordinate2D(latitude: 37.489_902, longitude: 127.041_819))
                    
                StoreListView()
                    .onAppear() {
                        // 데이터 받아오기
                    }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    MapAndStoreListView()
}
