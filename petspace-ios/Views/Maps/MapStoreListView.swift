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
    
    @State var presentationDetents: Set<PresentationDetent> = [.fraction(0.1), .medium, .large]
    @State var currentDetent: PresentationDetent = .medium
    
    // 저장된 스토어 보여주는 여부
    @State private var isSavedStoreShowing: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // 지도 뷰
                MapView(storeViewModel: storeViewModel, mapViewModel: mapViewModel, profileViewModel: profileViewModel)
                
                // 버튼 Bar
                ButtonBarView(alignment: .topTrailing, isSavedStoreShowing: $isSavedStoreShowing, mapViewModel: mapViewModel, profileViewModel: profileViewModel)
                
                // Store List View
                // StoreListView(mapViewModel: mapViewModel, storeViewModel: storeViewModel, profileViewModel: profileViewModel)
            }
            .ignoresSafeArea(edges: .bottom)
            .sheet(isPresented: .constant(true), content: {
                StoreListViewV2(mapViewModel: mapViewModel, storeViewModel: storeViewModel, profileViewModel: profileViewModel, presentationDetents: $presentationDetents, currentDetent: $currentDetent)
                    .presentationDetents(presentationDetents, selection: $currentDetent)
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(30.0)
                    .presentationBackgroundInteraction(.enabled)
                    .interactiveDismissDisabled()
            })
        }
    }
}

struct MapStoreListViewV2: View {
    
    @ObservedObject var storeViewModel: StoreViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    @State var presentationDetents: Set<PresentationDetent> = [.fraction(0.1), .medium, .large]
    @State var currentDetent: PresentationDetent = .medium
    
    // 저장된 스토어 보여주는 여부
    @State private var isSavedStoreShowing: Bool = false
    
    var body: some View {
        ZStack {
            MapViewV2(storeViewModel: storeViewModel, mapViewModel: mapViewModel, profileViewModel: profileViewModel)
            
            ButtonBarView(alignment: .topLeading, isSavedStoreShowing: $isSavedStoreShowing, mapViewModel: mapViewModel, profileViewModel: profileViewModel)
        }
        .sheet(isPresented: .constant(true), content: {
            StoreListViewV2(mapViewModel: mapViewModel, storeViewModel: storeViewModel, profileViewModel: profileViewModel, presentationDetents: $presentationDetents, currentDetent: $currentDetent)
                .presentationDetents(presentationDetents, selection: $currentDetent)
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(30.0)
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
        })
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

#Preview {
    @ObservedObject var storeViewModel = StoreViewModel()
    @ObservedObject var mapViewModel = MapViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    return Group {
        TabView {
            MapStoreListViewV2(storeViewModel: storeViewModel, mapViewModel: mapViewModel, profileViewModel: profileViewModel)
                .tabItem {
                    Label("Test", systemImage: "star")
                }
        }
    }
}
