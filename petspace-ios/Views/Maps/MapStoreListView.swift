//
//  MapStoreListView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI
import CoreLocation

struct MapStoreListView: View {
    
    @ObservedObject var storeViewModel: StoreViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    // 저장된 스토어 보여주는 여부
    @State private var isSavedStoreShowing: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // 지도 뷰
                MapView(storeViewModel: storeViewModel, mapViewModel: mapViewModel, profileViewModel: profileViewModel)
                
                // 버튼 Bar
                ButtonBarView(isSavedStoreShowing: $isSavedStoreShowing, mapViewModel: mapViewModel, profileViewModel: profileViewModel)
                
                // Store List View
                StoreListView(mapViewModel: mapViewModel, storeViewModel: storeViewModel, profileViewModel: profileViewModel)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    @ObservedObject var storeViewModel = StoreViewModel()
    @ObservedObject var mapViewModel = MapViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    return Group {
        MapStoreListView(storeViewModel: storeViewModel, mapViewModel: mapViewModel, profileViewModel: profileViewModel)
    }
}
