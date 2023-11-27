//
//  MapView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI
import CoreLocation
import MapKit

struct MapView: View {
    
    @ObservedObject var storeViewModel: StoreViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    // map span
    // @State private var mapSpan: CLLocationDegrees
    
    // Map 카메라 Position
    @State var mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.484_902, longitude: 127.041_819), span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)))
    
    // 지도 Routing 관련
    @State private var routeDisplaying: Bool = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    @State private var etaResult: MKDirections.ETAResponse?
    
    // 선택된 Annotation
    @State private var selectedAnnotationId: String = ""
    
    var body: some View {
        ZStack {
            Map(initialPosition: mapCameraPosition) {
                ForEach(storeViewModel.store.filter( { selectedAnnotationId == "" ? true : ($0.id == selectedAnnotationId) } )) { storeItem in
                    Annotation(storeItem.name, coordinate: CLLocationCoordinate2D(latitude: storeItem.coordinate.latitude, longitude: storeItem.coordinate.longitude)) {
                        
                        StoreAnnotation(profileViewModel: profileViewModel,
                                        mapViewModel: mapViewModel,
                                        storeItem: storeItem,
                                        routeDisplaying: $routeDisplaying,
                                        route: $route,
                                        mapCameraPosition: $mapCameraPosition,
                                        etaResult: $etaResult,
                                        selectedAnnotationId: $selectedAnnotationId
                        )
                    }
                }
                
                UserAnnotation()
                
                if let route {
                    MapPolyline(route.polyline)
                        .stroke(.blue, lineWidth: 6)
                }
            }
            .ignoresSafeArea()
            .mapControls {
//                MapCompass()
//                MapPitchToggle()
//                MapUserLocationButton()
            }
            .mapStyle(.standard)
            
            /* GroupBox {
                Text("\(mapViewModel.userLatitude), \(mapViewModel.userLongitude)")
            }.padding(.bottom, 500)*/
        }
        .onAppear() {
            mapViewModel.locationManager?.startUpdatingLocation()
        }
        .onDisappear() {
            mapViewModel.locationManager?.stopUpdatingLocation()
        }
    }
}

/* #Preview {
    @ObservedObject var storeViewModel = StoreViewModel()
    @ObservedObject var mapViewModel = MapViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    return Group {
        MapView(storeViewModel: storeViewModel, mapViewModel: mapViewModel, profileViewModel: profileViewModel)
    }
} */

struct MapViewV2: View {
    @ObservedObject var storeViewModel: StoreViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    // Map Camera
    /* @State var locationCoordinate: CLLocationCoordinate2D
    @State var coordinateSpan: MKCoordinateSpan
    @State var coordinateRegion: MKCoordinateRegion
    @State var mapCameraPosition: MapCameraPosition
    @State var mapCamera: MapCamera*/
    
    @State private var mapCameraPosition: MapCameraPosition = MapCameraPosition.camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 37.498_600, longitude: 127.041_800), distance: 24000, heading: 0, pitch: 0))
    // @State private var mapCamera: MapCamera = MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 37.498_600, longitude: 127.041_800), distance: 24000, heading: 0, pitch: 0)
    let mapCameraBounds: MapCameraBounds = MapCameraBounds(minimumDistance: 600,
                                                                    maximumDistance: 1200000)
    
    // distance
    @State private var lastDistance: Double = 24000
    
    // last center
    @State private var lastLatitude: CLLocationDegrees = 37.498_600
    @State private var lastLongitude: CLLocationDegrees = 127.041_800
    
    // 지도 Routing 관련
    @State private var routeDisplaying: Bool = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    @State private var etaResult: MKDirections.ETAResponse?
    @State private var isLoading: Bool = false
    
    // Store Preview
    @State var isPreviewPresented: Bool = false
    @State var selectedStore: Store.Data.StoreItem?
    
    // Sheet selection
    @State private var presentationDetents: Set<PresentationDetent> = [.fraction(0.3), .fraction(0.3000001)]
    @State private var detentSelection: PresentationDetent = .fraction(0.3)
    
    @State private var sheetScreenType: MapSheetScreenMode = .hidden
    
    // 경로 로딩
    // @State private var isRouteLoading: Bool = false
    
    var body: some View {
        Map(position: $mapCameraPosition, bounds: mapCameraBounds) {
        // Map(initialPosition: .camera(mapCamera), bounds: mapCameraBounds) {
            UserAnnotation()
            
            // 경로를 보여주는 경우
            if routeDisplaying {
                if let selectedStore {
                    Annotation(selectedStore.name, coordinate: CLLocationCoordinate2D(latitude: selectedStore.coordinate.latitude, longitude: selectedStore.coordinate.longitude)) {
                        StoreAnnotationV2(storeItem: selectedStore, mapCameraPosition: $mapCameraPosition, isPreviewPresented: $isPreviewPresented, selectedStore: $selectedStore, sheetScreenType: $sheetScreenType)
                    }
                }
                
                if let route {
                    MapPolyline(route.polyline)
                        .stroke(.blue, lineWidth: 6)
                }
            }
            else {
                // 확대된 경우 전부 표시
                if lastDistance < 40000 {
                    ForEach(storeViewModel.store) { storeItem in
                        Annotation(storeItem.name, coordinate: CLLocationCoordinate2D(latitude: storeItem.coordinate.latitude, longitude: storeItem.coordinate.longitude)) {
                            StoreAnnotationV2(storeItem: storeItem, mapCameraPosition: $mapCameraPosition, isPreviewPresented: $isPreviewPresented, selectedStore: $selectedStore, sheetScreenType: $sheetScreenType)
                        }
                    }
                }
                // 클러스터링
                else {
                    let clusters = clusterAnnotations(clusterRadius: 2 * (lastDistance / 120_000))
                    
                    ForEach(clusters) { cluster in
                        Annotation("", coordinate: cluster.center) {
                            ClusteredAnnotation(cluster: cluster, mapCameraPosition: $mapCameraPosition)
                        }
                    }
                }
            }
        }
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
            MapScaleView()
        }
        .controlSize(.mini)
        .safeAreaPadding()
        .onMapCameraChange { mapCameraUpdateContext in
            print("mapCam distance: \(mapCameraUpdateContext.camera.distance)")
            print("mapCam Center: (\(mapCameraUpdateContext.camera.centerCoordinate.latitude), \(mapCameraUpdateContext.camera.centerCoordinate.longitude))")
            
            // 확대, 축소 비율이 1.1 이상 변한 경우만 업데이트
            /* print("map distance ratio: \(max(lastDistance, mapCameraUpdateContext.camera.distance) / min(lastDistance, mapCameraUpdateContext.camera.distance))")
            if max(lastDistance, mapCameraUpdateContext.camera.distance) / min(lastDistance, mapCameraUpdateContext.camera.distance) > 1.1 && lastDistance >= 40000 {
                clusters = clusterAnnotations(clusterRadius: 2 * (lastDistance / 120_000))
            }*/
            
            lastDistance = mapCameraUpdateContext.camera.distance
            lastLatitude = mapCameraUpdateContext.camera.centerCoordinate.latitude
            lastLongitude = mapCameraUpdateContext.camera.centerCoordinate.longitude
        }
        .sheet(isPresented: $isPreviewPresented, onDismiss: {
            resetRoute()
            changeSheetMode(to: .previewStore)
        }, content: {
            withAnimation(.spring()) {
                VStack {
                    switch sheetScreenType {
                    case .hidden:
                        ProgressView()
                    case .routeButton:
                        HStack {
                            // 닫기 버튼
                            Button {
                                resetRoute()
                                changeSheetMode(to: .previewStore)
                                if let selectedStore {
                                    withAnimation(.spring()) {
                                        mapCameraPosition = .camera(MapCamera(centerCoordinate: selectedStore.locationCoordinate, distance: 2000, heading: 0, pitch: 0))
                                    }
                                }
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15.0)
                                        .fill(Color.black)
                                    
                                    VStack {
                                        Image(systemName: "xmark.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .bold()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(Color.white)
                                            .padding(.top, 3)
                                        Text("닫기")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color.white)
                                    }
                                }
                                .frame(width: 60, height: 60)
                            }
                            
                            // 경로 새로고침 버튼
                            Button {
                                fetchRoute()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15.0)
                                        .fill(Color.blue)
                                    
                                    VStack {
                                        Image(systemName: "arrow.circlepath")
                                            .resizable()
                                            .scaledToFit()
                                            .bold()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)
                                            .padding(.top, 3)
                                        Text("새고로침")
                                            .font(.system(size: 11))
                                            .foregroundColor(.white)
                                    }
                                }
                                .frame(width: 60, height: 60)
                            }
                            .disabled(isLoading)
                            
                            if let etaResult {
                                VStack {
                                    Text("\(String(format: "%.2f", (etaResult.distance / 1000)))km")
                                        .fixedSize(horizontal: true, vertical: true)
                                    Text("\(String(format: "%.0f", (etaResult.expectedTravelTime / 60)))분 예정")
                                        .fixedSize(horizontal: true, vertical: true)
                                }
                                .frame(maxWidth: .infinity)
                            } else {
                                if isLoading {
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                } else {
                                    Text("경로를 찾을 수 없어요")
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            
                            // 자세히 버튼
                            Button {
                                resetRoute()
                                changeSheetMode(to: .detailView)
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15.0)
                                        .fill(Color.gray)
                                    
                                    VStack {
                                        Image(systemName: "info.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .bold()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)
                                            .padding(.top, 3)
                                        Text("자세히")
                                            .font(.system(size: 11))
                                            .foregroundColor(.white)
                                    }
                                }
                                .frame(width: 60, height: 60)
                            }
                        }
                        .padding(.horizontal, 10)
                        
                    case .previewStore:
                        if let selectedStore {
                            StorePreviewView(mapViewModel: mapViewModel, profileViewModel: profileViewModel, storeItem: selectedStore)
                            HStack {
                                // 저장 버튼
                                Button {
                                    //
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .fill(Color("Background1"))
                                            .stroke(Color("Stroke1"), lineWidth: 1)
                                        
                                        VStack {
                                            Image(systemName: "heart")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                            Text("저장")
                                                .font(.system(size: 10))
                                        }
                                    }
                                    .frame(height: 60)
                                }
                                
                                // 경로 버튼
                                Button {
                                    fetchRoute()
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .fill(Color("Background1"))
                                            .stroke(Color("Stroke1"), lineWidth: 1)
                                        
                                        if isLoading {
                                            VStack {
                                                ProgressView()
                                                    .frame(width: 20, height: 20)
                                                Text("탐색중")
                                                    .font(.system(size: 10))
                                            }
                                        } else {
                                            VStack {
                                                Image(systemName: "arrow.triangle.turn.up.right.circle")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 20, height: 20)
                                                Text("경로")
                                                    .font(.system(size: 10))
                                            }
                                        }
                                        
                                    }
                                    .frame(height: 60)
                                }
                                .disabled((mapViewModel.userLatitude == 0.0 || mapViewModel.userLongitude == 0.0) || isLoading)
                                
                                Button {
                                    // 전화 걸기
                                    let formattedString = "tel://" + selectedStore.tel
                                    print(formattedString)
                                    guard let phoneUrl = URL(string: formattedString) else { return }
                                    UIApplication.shared.open(phoneUrl)
                                    GATracking.sendLogEvent(eventName: GATracking.DetailViewMessage.DETAIL_PAGE_CALL_CLICK, params: nil)
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .fill(Color("Background1"))
                                            .stroke(Color("Stroke1"), lineWidth: 1)
                                        
                                        VStack {
                                            Image(systemName: "phone.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                            Text("전화")
                                                .font(.system(size: 10))
                                        }
                                    }
                                    .frame(height: 60)
                                }
                                
                                Button {
                                    //
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .fill(Color("Background1"))
                                            .stroke(Color("Stroke1"), lineWidth: 1)
                                        
                                        VStack {
                                            Image(systemName: "book.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                            Text("예약")
                                                .font(.system(size: 10))
                                        }
                                    }
                                    .frame(height: 60)
                                }
                                .disabled(true)
                                
                                Button {
                                    changeSheetMode(to: .detailView)
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .fill(Color("Background1"))
                                            .stroke(Color("Stroke1"), lineWidth: 1)
                                        
                                        VStack {
                                            Image(systemName: "info.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                            Text("자세히")
                                                .font(.system(size: 10))
                                        }
                                    }
                                    .frame(height: 60)
                                }
                                
                                Button {
                                    changeSheetMode(to: .hidden)
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10.0)
                                            .fill(Color("Background1"))
                                            .stroke(Color("Stroke1"), lineWidth: 1)
                                        
                                        VStack {
                                            Image(systemName: "xmark.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                            Text("닫기")
                                                .font(.system(size: 10))
                                        }
                                    }
                                    .frame(height: 60)
                                }
                            }
                            .padding(.horizontal, 14)
                        }
                        else {
                            ProgressView()
                        }
                    case .detailView:
                        if let selectedStore {
                            DetailView(storeItem: selectedStore, isPresented: $isPreviewPresented, profileViewModel: profileViewModel, mapViewModel: mapViewModel)
                                .background(Color("Background2"))
                        }
                        else {
                            ProgressView()
                        }
                    }
                }
                .presentationDetents(presentationDetents, selection: $detentSelection)
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(30.0)
                .presentationBackgroundInteraction(.enabled)
            }
        })
    }
    
    func clusterAnnotations(clusterRadius: Double) -> [Cluster] {
        var clusters: [Cluster] = []
        
        for store in storeViewModel.store {
            var isClustered = false
            
            var clusterId: Int = 0
            for cluster in clusters {
                let distance = calculateDistance(itemCoord: cluster.center, mvCoord: store.locationCoordinate)
                
                if distance <= clusterRadius {
                    cluster.points.append(store.locationCoordinate)
                    isClustered = true
                    // print("store appended to cluster \(clusterId): \(distance)")
                    break
                }
                clusterId += 1
            }
            
            if !isClustered {
                let newCluster = Cluster(center: store.locationCoordinate, points: [store.locationCoordinate])
                clusters.append(newCluster)
                // print("new \(clusters.count)th cluster created: \(newCluster.center)")
            }
            
        }
        
        print("number of clusters: \(clusters.count)")
        return clusters
    }
    
    func fetchRoute() {
        isLoading = true
        
        if let selectedStore = selectedStore {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: CLLocationCoordinate2D(latitude: mapViewModel.userLatitude, longitude: mapViewModel.userLongitude)))
            request.destination = MKMapItem(placemark: .init(coordinate: selectedStore.locationCoordinate))
            
            print("source: \(mapViewModel.currentRegion.center)) -> to: \(selectedStore.locationCoordinate))")
            
            Task {
                let result = try? await MKDirections(request: request).calculate()
                etaResult = try? await MKDirections(request: request).calculateETA()
                route = result?.routes.first
                routeDestination = MKMapItem(placemark: .init(coordinate: selectedStore.locationCoordinate))
                
                if let etaResult = etaResult {
                    print("distance: \(String(describing: etaResult.distance))")
                    print("eta: \(String(describing: etaResult.expectedTravelTime))")
                    print("departure date: \(String(describing: etaResult.expectedDepartureDate))")
                    print("arrival date: \(String(describing: etaResult.expectedArrivalDate))")
                    print("transport type: \(String(describing: etaResult.transportType))")
                    
                    withAnimation(.spring()) {
                        routeDisplaying = true
                        
                        if let rect = route?.polyline.boundingMapRect {
                            mapCameraPosition = .rect(rect)
                            changeSheetMode(to: .routeButton)
                        }
                    }
                } 
                
                isLoading = false
            }
        } else {
            isLoading = false
        }
    }
    
    func resetRoute() {
        withAnimation(.spring()) {
            routeDisplaying = false
            etaResult = nil
            route = nil
            routeDestination = nil
        }
    }
    
    func changeSheetMode(to: MapSheetScreenMode) {
        withAnimation(.spring()) {
            sheetScreenType = to
        }
        
        var newDetent: PresentationDetent
        var newPresentationDetents: Set<PresentationDetent>
        switch to {
        case .hidden:
            isPreviewPresented = false
            newPresentationDetents = [.fraction(0.3), .fraction(0.3000001)]
            newDetent = .fraction(0.3)
        case .routeButton:
            newPresentationDetents = [.fraction(0.12), .fraction(0.1200001)]
            newDetent = .fraction(0.12)
        case .previewStore:
            newPresentationDetents = [.fraction(0.3), .fraction(0.3000001)]
            newDetent = .fraction(0.3)
        case .detailView:
            newPresentationDetents = [.large]
            newDetent = .large
        }
        
        withAnimation(.spring()) {
            presentationDetents = newPresentationDetents
            detentSelection = newDetent
        }
    }
}

enum MapSheetScreenMode {
    case hidden
    case routeButton
    case previewStore
    case detailView
}

#Preview {
    @ObservedObject var storeViewModel = StoreViewModel()
    @ObservedObject var mapViewModel = MapViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    return Group {
        MapViewV2(storeViewModel: storeViewModel, mapViewModel: mapViewModel, profileViewModel: profileViewModel)
    }
}

struct MapOneView: View {
    @State var storeItem: Store.Data.StoreItem
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    // 지도 Routing 관련
    @State private var routeDisplaying: Bool = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    @State private var etaResult: MKDirections.ETAResponse?
    
    // Map 카메라 Position
    @State var mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.484_902, longitude: 127.041_819), span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)))
    
    // 결과가 나왔는지
    @State private var isLoading: Bool = false
    @State private var isResult: Bool = false
    
    // 확대 여부
    @State private var isExpanded: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(initialPosition: MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: storeItem.coordinate.latitude, longitude: storeItem.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))) {
                
                Annotation(storeItem.name, coordinate: CLLocationCoordinate2D(latitude: storeItem.coordinate.latitude, longitude: storeItem.coordinate.longitude)) {
                    StoreAnnotation(profileViewModel: profileViewModel, 
                                    mapViewModel: mapViewModel,
                                    storeItem: storeItem,
                                    allowExpand: false, 
                                    routeDisplaying: $routeDisplaying,
                                    route: $route,
                                    mapCameraPosition: $mapCameraPosition,
                                    etaResult: $etaResult,
                                    selectedAnnotationId: .constant(storeItem.id)
                    )
                }
                
                if let route {
                    MapPolyline(route.polyline)
                        .stroke(.blue, lineWidth: 6)
                }
            }
            .ignoresSafeArea()
            .mapStyle(.standard)
            .onAppear() {
                mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: storeItem.locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)))
            }
            
            HStack {
                Button {
                    withAnimation(.spring()) {
                        isResult = true
                        isLoading = true
                        fetchRoute()
                    }
                    // 경로 탐색 시작
                } label: {
                    VStack {
                        if isLoading {
                            ProgressView()
                                .frame(width: 16, height: 16)
                        } else {
                            Image(systemName: isResult ? "goforward" : "arrow.triangle.turn.up.right.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                        }
                        Text(isResult ? "새로고침" : "경로")
                            .font(.system(size: 8))
                            .foregroundStyle(mapViewModel.userLatitude == 0.0 || mapViewModel.userLongitude == 0.0 ? .gray : .blue)
                            .fixedSize(horizontal: true, vertical: true)
                    }
                }
                .padding(.horizontal, isResult ? 0 : 6)
                .disabled(mapViewModel.userLatitude == 0.0 || mapViewModel.userLongitude == 0.0)
                
                if isResult {
                    if let etaResult = etaResult {
                        Text("\(String(format: "%.1f", (etaResult.distance / 1000)))km ∙ \(String(format: "%.0f", (etaResult.expectedTravelTime / 60)))분 예정")
                            .font(.system(size: 12))
                            .padding(.horizontal, 8)
                            .fixedSize(horizontal: true, vertical: true)
                        
                        Button {
                            // 경로 삭제
                            withAnimation(.spring()) {
                                isResult = false
                                routeDisplaying = false
                                route = nil
                                routeDestination = nil
                            }
                            // routeDisplaying = false
                            // route = nil
                            // routeDestination = nil
                        } label: {
                            VStack {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                Text("삭제")
                                    .font(.system(size: 8))
                                    .foregroundStyle(.blue)
                                    .fixedSize(horizontal: true, vertical: true)
                            }
                        }
                    }
                }
                
                Button {
                    withAnimation(.spring()) {
                        isExpanded.toggle()
                    }
                } label: {
                    VStack {
                        Image(systemName: isExpanded ? "arrow.up.right.and.arrow.down.left.circle" : "arrow.down.left.and.arrow.up.right.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        Text(isExpanded ? "축소" : "확대")
                            .font(.system(size: 8))
                            .foregroundStyle(.blue)
                            .fixedSize(horizontal: true, vertical: true)
                    }
                }
                .padding(.horizontal, 6)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .materialBackground()
            .padding(.bottom, 8)
        }
        .cornerRadius(10)
        .frame(height: isExpanded ? 600 : 300)
    }
    
    func fetchRoute() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: .init(coordinate: CLLocationCoordinate2D(latitude: mapViewModel.userLatitude, longitude: mapViewModel.userLongitude)))
        request.destination = MKMapItem(placemark: .init(coordinate: storeItem.locationCoordinate))
        
        print("source: \(mapViewModel.currentRegion.center)) -> to: \(storeItem.locationCoordinate))")
        
        Task {
            let result = try? await MKDirections(request: request).calculate()
            etaResult = try? await MKDirections(request: request).calculateETA()
            route = result?.routes.first
            routeDestination = MKMapItem(placemark: .init(coordinate: storeItem.locationCoordinate))
            
            if let etaResult = etaResult {
                print("distance: \(String(describing: etaResult.distance))")
                print("eta: \(String(describing: etaResult.expectedTravelTime))")
                print("departure date: \(String(describing: etaResult.expectedDepartureDate))")
                print("arrival date: \(String(describing: etaResult.expectedArrivalDate))")
                print("transport type: \(String(describing: etaResult.transportType))")
            }
            
            withAnimation(.snappy) {
                routeDisplaying = true
                
                if let rect = route?.polyline.boundingMapRect, routeDisplaying {
                    mapCameraPosition = .rect(rect)
                }
                isLoading = false
            }
        }
    }
}

struct MapOneViewV2: View {
    @State var storeItem: Store.Data.StoreItem
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    // 지도 Routing 관련
    @State private var routeDisplaying: Bool = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    @State private var etaResult: MKDirections.ETAResponse?
    
    @State private var mapCameraPosition: MapCameraPosition = MapCameraPosition.camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 37.498_600, longitude: 127.041_800), distance: 24000, heading: 0, pitch: 0))
    // @State private var mapCamera: MapCamera = MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 37.498_600, longitude: 127.041_800), distance: 24000, heading: 0, pitch: 0)
    let mapCameraBounds: MapCameraBounds = MapCameraBounds(minimumDistance: 200,
                                                                    maximumDistance: 1200000)
    
    // 결과가 나왔는지
    @State private var isLoading: Bool = false
    @State private var isResult: Bool = false
    
    // 확대 여부
    @State private var isExpanded: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $mapCameraPosition, bounds: mapCameraBounds) {
                
                UserAnnotation()
                
                Annotation(storeItem.name, coordinate: CLLocationCoordinate2D(latitude: storeItem.coordinate.latitude, longitude: storeItem.coordinate.longitude)) {
                    AsyncImage(url: URL(string: storeItem.iconImage)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 30, height: 30)
                    .shadow(radius: 5)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            mapCameraPosition = MapCameraPosition.camera(MapCamera(centerCoordinate: storeItem.locationCoordinate, distance: 2000, heading: 0, pitch: 0))
                        }
                    }
                }
                
                if let route {
                    MapPolyline(route.polyline)
                        .stroke(.blue, lineWidth: 6)
                }
            }
            .mapControls {
                MapCompass()
                MapPitchToggle()
                MapUserLocationButton()
                MapScaleView()
            }
            .controlSize(.mini)
            .onAppear {
                mapCameraPosition = MapCameraPosition.camera(MapCamera(centerCoordinate: storeItem.locationCoordinate, distance: 2000, heading: 0, pitch: 0))
            }
            
            HStack {
                Button {
                    withAnimation(.spring()) {
                        isResult = true
                        isLoading = true
                        fetchRoute()
                    }
                    // 경로 탐색 시작
                } label: {
                    VStack {
                        if isLoading {
                            ProgressView()
                                .frame(width: 16, height: 16)
                        } else {
                            Image(systemName: isResult ? "goforward" : "arrow.triangle.turn.up.right.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                        }
                        Text(isResult ? "새로고침" : "경로")
                            .font(.system(size: 8))
                            .foregroundStyle(mapViewModel.userLatitude == 0.0 || mapViewModel.userLongitude == 0.0 ? .gray : .blue)
                            .fixedSize(horizontal: true, vertical: true)
                    }
                }
                .padding(.horizontal, isResult ? 0 : 6)
                .disabled(mapViewModel.userLatitude == 0.0 || mapViewModel.userLongitude == 0.0)
                
                if isResult {
                    if let etaResult = etaResult {
                        Text("\(String(format: "%.1f", (etaResult.distance / 1000)))km\n\(String(format: "%.0f", (etaResult.expectedTravelTime / 60)))분 예정")
                            .font(.system(size: 12))
                            .padding(.horizontal, 8)
                            .fixedSize(horizontal: true, vertical: true)
                        
                        Button {
                            // 경로 삭제
                            isResult = false
                            isLoading = false
                            resetRoute()
                        } label: {
                            VStack {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                Text("삭제")
                                    .font(.system(size: 8))
                                    .foregroundStyle(.blue)
                                    .fixedSize(horizontal: true, vertical: true)
                            }
                        }
                    }
                }
                
                Button {
                    withAnimation(.spring()) {
                        isExpanded.toggle()
                        
                        withAnimation(.spring()) {
                            mapCameraPosition = MapCameraPosition.camera(MapCamera(centerCoordinate: storeItem.locationCoordinate, distance: 2000, heading: 0, pitch: 0))
                        }
                    }
                } label: {
                    VStack {
                        Image(systemName: isExpanded ? "arrow.up.right.and.arrow.down.left.circle" : "arrow.down.left.and.arrow.up.right.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        Text(isExpanded ? "축소" : "확대")
                            .font(.system(size: 8))
                            .foregroundStyle(.blue)
                            .fixedSize(horizontal: true, vertical: true)
                    }
                }
                .padding(.horizontal, 6)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .materialBackground()
            .padding(.bottom, 8)
        }
        .cornerRadius(10)
        .frame(height: isExpanded ? 600 : 300)
    }
    
    func fetchRoute() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: .init(coordinate: CLLocationCoordinate2D(latitude: mapViewModel.userLatitude, longitude: mapViewModel.userLongitude)))
        request.destination = MKMapItem(placemark: .init(coordinate: storeItem.locationCoordinate))
        
        print("source: \(mapViewModel.currentRegion.center)) -> to: \(storeItem.locationCoordinate))")
        
        Task {
            let result = try? await MKDirections(request: request).calculate()
            etaResult = try? await MKDirections(request: request).calculateETA()
            route = result?.routes.first
            routeDestination = MKMapItem(placemark: .init(coordinate: storeItem.locationCoordinate))
            
            if let etaResult = etaResult {
                print("distance: \(String(describing: etaResult.distance))")
                print("eta: \(String(describing: etaResult.expectedTravelTime))")
                print("departure date: \(String(describing: etaResult.expectedDepartureDate))")
                print("arrival date: \(String(describing: etaResult.expectedArrivalDate))")
                print("transport type: \(String(describing: etaResult.transportType))")
                
                withAnimation(.spring()) {
                    routeDisplaying = true
                    isExpanded = true
                    
                    if let rect = route?.polyline.boundingMapRect {
                        mapCameraPosition = .rect(rect)
                    }
                }
            }
            isLoading = false
        }
    }
    
    func resetRoute() {
        withAnimation(.spring()) {
            routeDisplaying = false
            isExpanded = false
            etaResult = nil
            route = nil
            routeDestination = nil
            
            mapCameraPosition = MapCameraPosition.camera(MapCamera(centerCoordinate: storeItem.locationCoordinate, distance: 2000, heading: 0, pitch: 0))
        }
    }
}

/* #Preview {
    @ObservedObject var storeViewModel = StoreViewModel()
    @ObservedObject var mapViewModel = MapViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    return Group {
        MapOneView(storeItem: storeViewModel.store[0], mapViewModel: mapViewModel, profileViewModel: profileViewModel)
            .padding(10)
    }
} */

#Preview {
    @ObservedObject var storeViewModel = StoreViewModel()
    @ObservedObject var mapViewModel = MapViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    return Group {
        MapOneViewV2(storeItem: storeViewModel.store[0], mapViewModel: mapViewModel, profileViewModel: profileViewModel)
            .padding(10)
    }
}

// Deprecated
struct StoreAnnotation: View {
    
    // Environment
    @Environment(\.dismiss) var dismiss
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var mapViewModel: MapViewModel
    
    @State var storeItem: Store.Data.StoreItem
    @State private var isDetailViewPresented: Bool = false
    
    // 버튼 확장 가능 여부
    var allowExpand: Bool = true
    @State private var isExpandedShowing: Bool = false
    
    @Binding var routeDisplaying: Bool
    @Binding var route: MKRoute?
    @State var routeDestination: MKMapItem?
    @Binding var mapCameraPosition: MapCameraPosition
    @Binding var etaResult: MKDirections.ETAResponse?
    
    // 선택된 Annotation 이름
    @Binding var selectedAnnotationId: String
    
    // 로딩중
    @State private var isLoading: Bool = false
    @State private var isResult: Bool = false
    
    var body: some View {
        VStack(spacing: 5) {
            // 이미지
            ZStack {
                AsyncImage(url: URL(string: storeItem.iconImage)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 40, height: 40)
                .background(Color.gray)
                .cornerRadius(20)
                .shadow(radius: 5)
                .onTapGesture {
                    if allowExpand && !isExpandedShowing {
                        withAnimation(.spring()) {
                            isExpandedShowing = true
                            GATracking.sendLogEvent(eventName: GATracking.MainViewMessage.MAP_ANNOTATION_CLICKED, params: nil)
                        }
                    }
                }
                
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: isExpandedShowing ? 0.5 : 0.0))
                
                if isExpandedShowing {
                    // 닫기 버튼
                    Button {
                        if resetSelectedID(selectedID: storeItem.id) {
                            routeDisplaying = false
                            route = nil
                            routeDestination = nil
                            etaResult = nil
                        }
                        
                        isLoading = false
                        isResult = false
                        
                        withAnimation(.spring()) {
                            isExpandedShowing = false
                            GATracking.sendLogEvent(eventName: GATracking.MainViewMessage.MAP_ANNOTATION_CLOSE, params: nil)
                        }
                    } label: {
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.white)
                    }
                }
                
            }
            
            // Detail View 보이기
            .sheet(isPresented: $isDetailViewPresented, onDismiss: {
                
            }, content: {
                DetailView(storeItem: storeItem, isPresented: $isDetailViewPresented, profileViewModel: profileViewModel, mapViewModel: mapViewModel)
                    .presentationDragIndicator(.visible)
                    .onAppear() {
                        // View 방문 이벤트
                        GATracking.eventScreenView(screenName: GATracking.ScreenNames.detailView)
                    }
                    .onDisappear() {
                        // View 방문 이벤트
                        GATracking.eventScreenView(screenName: GATracking.ScreenNames.mainView)
                    }
            })
            
            if allowExpand {
                // 가격 및 별점
                HStack {
                    if isExpandedShowing {
                        HStack(alignment: .center, spacing: 14) {
                            // 좋아요
                            /* Button {
                                
                            } label: {
                                VStack {
                                    Image(systemName: "heart")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                    Text("저장")
                                        .font(.system(size: 8))
                                        .foregroundStyle(.blue)
                                        .fixedSize(horizontal: true, vertical: true)
                                }
                            }*/
                            
                            // 경로
                            /* Button {
                                if updateSelectedID(selectedID: storeItem.id) {
                                    isLoading = true
                                    fetchRoute()
                                    
                                    if isResult {
                                        // 새고로침
                                        GATracking.sendLogEvent(eventName: GATracking.MainViewMessage.MAP_ANNOTATION_ROUTE_REFRESH, params: nil)
                                    } else {
                                        // 경로 생성
                                        GATracking.sendLogEvent(eventName: GATracking.MainViewMessage.MAP_ANNOTATION_ROUTE_START, params: nil)
                                    }
                                }
                                // selectedAnnotationId = storeItem.id
                            } label: {
                                VStack {
                                    if isLoading {
                                        ProgressView()
                                            .frame(width: 16, height: 16)
                                    } else {
                                        Image(systemName: isResult ? "goforward" : "arrow.triangle.turn.up.right.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                    }
                                    Text(isResult ? "새로고침" : "경로")
                                        .font(.system(size: 8))
                                        .foregroundStyle(mapViewModel.userLatitude == 0.0 || mapViewModel.userLongitude == 0.0 ? .gray : .blue)
                                        .fixedSize(horizontal: true, vertical: true)
                                }
                                
                            }
                            .disabled(mapViewModel.userLatitude == 0.0 || mapViewModel.userLongitude == 0.0)*/
                            
                            if let etaResult = etaResult {
                                VStack {
                                    Text("\(String(format: "%.1f", (etaResult.distance / 1000)))km")
                                        .font(.system(size: 12))
                                        .fixedSize(horizontal: true, vertical: true)
                                    Text("\(String(format: "%.0f", (etaResult.expectedTravelTime / 60)))분 예정")
                                        .font(.system(size: 12))
                                        .fixedSize(horizontal: true, vertical: true)
                                }
                                .padding(.horizontal, 1)
                            }
                            
                            // 전화 걸기
                            Button {
                                let formattedString = "tel://" + storeItem.tel
                                print(formattedString)
                                guard let phoneUrl = URL(string: formattedString) else { return }
                                UIApplication.shared.open(phoneUrl)
                                GATracking.sendLogEvent(eventName: GATracking.MainViewMessage.MAP_ANNOTATION_CALL, params: nil)
                            } label: {
                                VStack {
                                    Image(systemName: "phone.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                    Text("전화")
                                        .font(.system(size: 8))
                                        .foregroundStyle(.blue)
                                        .fixedSize(horizontal: true, vertical: true)
                                }
                            }
                            .disabled(storeItem.tel == "")
                            
                            // 바로 예약
                            Button {
                                print("booking button pressed")
                                // 예약 페이지로
                            } label: {
                                VStack {
                                    Image(systemName: "book.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                    Text("바로예약")
                                        .font(.system(size: 8))
                                        .foregroundStyle(.gray)
                                        .fixedSize(horizontal: true, vertical: true)
                                }
                                
                            }
                            .disabled(true)
                            
                            // 자세히
                            Button {
                                print("detail button pressed")
                                isDetailViewPresented = true
                                GATracking.sendLogEvent(eventName: GATracking.MainViewMessage.MAP_ANNOTATION_DETAIL_OPEN, params: nil)
                            } label: {
                                VStack {
                                    Image(systemName: "info.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                    Text("자세히")
                                        .font(.system(size: 8))
                                        .foregroundStyle(.blue)
                                        .fixedSize(horizontal: true, vertical: true)
                                }
                                
                            }
                            
                            // 닫기
                            /* Button {
                                withAnimation(.spring()) {
                                    isExpandedShowing = false
                                }
                                print("close button pressed")
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            } */
                        }
                        .padding()
                        .padding(.horizontal, 2)
                    }
                    else {
                        if storeItem.rating <= 0 {
                            Text("\(storeItem.pricing.cut) ~")
                              .font(Font.custom("SF Pro Text", size: 11))
                              .foregroundColor(.white)
                              .padding(.leading, 6)
                              .padding(.trailing, 6)
                        } else {
                            Text("✦ \(String(format: "%.1f", storeItem.rating)) ∙ \(storeItem.pricing.cut) ~")
                              .font(Font.custom("SF Pro Text", size: 11))
                              .foregroundColor(.white)
                              .padding(.leading, 6)
                              .padding(.trailing, 6)
                        }
                    }
                }
                .frame(height: isExpandedShowing ? 52 : 20)
                .background(isExpandedShowing ? .clear : Color(red: 0, green: 0.64, blue: 1).opacity(0.6))
                .materialBackground()
                .cornerRadius(.infinity)
            }
        }
    }
    
    func fetchRoute() {
        
        if mapViewModel.userLatitude == 0.0 || mapViewModel.userLongitude == 0.0 {
            return
        }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: .init(coordinate: CLLocationCoordinate2D(latitude: mapViewModel.userLatitude, longitude: mapViewModel.userLongitude)))
        request.destination = MKMapItem(placemark: .init(coordinate: storeItem.locationCoordinate))
        
        print("source: \(mapViewModel.currentRegion.center)) -> to: \(storeItem.locationCoordinate))")
        
        Task {
            let result = try? await MKDirections(request: request).calculate()
            etaResult = try? await MKDirections(request: request).calculateETA()
            route = result?.routes.first
            routeDestination = MKMapItem(placemark: .init(coordinate: storeItem.locationCoordinate))
            
            if let etaResult = etaResult {
                print("distance: \(String(describing: etaResult.distance))")
                print("eta: \(String(describing: etaResult.expectedTravelTime))")
                print("departure date: \(String(describing: etaResult.expectedDepartureDate))")
                print("arrival date: \(String(describing: etaResult.expectedArrivalDate))")
                print("transport type: \(String(describing: etaResult.transportType))")
            }
            
            withAnimation(.snappy) {
                routeDisplaying = true
                
                if let rect = route?.polyline.boundingMapRect {
                    mapCameraPosition = .rect(rect)
                    print("rect: \(mapCameraPosition)")
                }
                isLoading = false
                isResult = true
            }
        }
    }
    
    private func updateSelectedID(selectedID: String) -> Bool {
        if selectedAnnotationId == "" || selectedAnnotationId == selectedID {
            selectedAnnotationId = selectedID
            print("selected Annotation Saved: \(selectedAnnotationId)")
            return true
        } else {
            print("selected: \(selectedAnnotationId) but queried by: \(selectedID)")
            return false
        }
    }
    
    private func resetSelectedID(selectedID: String) -> Bool {
        if selectedAnnotationId == selectedID {
            selectedAnnotationId = ""
            print("selected Annotation Reseted: \(selectedAnnotationId)")
            return true
        } else {
            print("selected: \(selectedAnnotationId) but queried by: \(selectedID)")
            return false
        }
    }
}

struct StoreAnnotationV2: View {
    
    // @ObservedObject var storeViewModel: StoreViewModel
    // @ObservedObject var profileViewModel: ProfileViewModel
    // @ObservedObject var mapViewModel: MapViewModel
    
    let storeItem: Store.Data.StoreItem
    @Binding var mapCameraPosition: MapCameraPosition
    @Binding var isPreviewPresented: Bool
    @Binding var selectedStore: Store.Data.StoreItem?
    @Binding var sheetScreenType: MapSheetScreenMode
    
    var body: some View {
        AsyncImage(url: URL(string: storeItem.iconImage)) { image in
            image
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
        } placeholder: {
            ProgressView()
        }
        .frame(width: 30, height: 30)
        .shadow(radius: 5)
        .onTapGesture {
            if sheetScreenType != .routeButton {
                selectedStore = storeItem
                
                if selectedStore != nil {
                    isPreviewPresented = true
                    sheetScreenType = .previewStore
                }
            }
            withAnimation(.spring()) {
                mapCameraPosition = .camera(MapCamera(centerCoordinate: storeItem.locationCoordinate, distance: 2000, heading: 0, pitch: 0))
            }
        }
        /* .sheet(isPresented: $isPresented) {
            StorePreviewView()
                .presentationDetents([.fraction(0.3)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(30.0)
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
        }*/
    }
}

struct ClusteredAnnotation: View {
    
    let cluster: Cluster
    @Binding var mapCameraPosition: MapCameraPosition
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .opacity(0.5)
                .frame(width: 30 + CGFloat(cluster.points.count / 2), height: 30 + CGFloat(cluster.points.count / 2))
                .shadow(radius: 5)
            
            Circle()
                // .stroke(Color.white, lineWidth: 5)
                .fill(Color(red: 0, green: 0.64, blue: 1).opacity(0.3 + 0.05 * Double(min(cluster.points.count, 10))))
                .frame(width: 24 + CGFloat(cluster.points.count / 2), height: 24 + CGFloat(cluster.points.count / 2))
            
            Text("\(cluster.points.count)")
                .font(.system(size: 12))
                .bold()
        }
        .onTapGesture {
            withAnimation(.spring()) {
                mapCameraPosition = .camera(MapCamera(centerCoordinate: cluster.center, distance: 10000, heading: 0, pitch: 0))
            }
        }
    }
}

/* #Preview {
    @ObservedObject var storeViewModel = StoreViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    @ObservedObject var mapViewModel = MapViewModel()
    @State var mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.484_902, longitude: 127.041_819), span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)))
    
    return Group {
        StoreAnnotation(profileViewModel: profileViewModel, mapViewModel: mapViewModel, storeItem: storeViewModel.store[0], routeDisplaying: .constant(false), route: .constant(nil), mapCameraPosition: $mapCameraPosition, etaResult: .constant(nil), selectedAnnotationId: .constant(storeViewModel.store[0].id))
        StoreAnnotation(profileViewModel: profileViewModel, mapViewModel: mapViewModel, storeItem: storeViewModel.store[1], routeDisplaying: .constant(false), route: .constant(nil), mapCameraPosition: $mapCameraPosition, etaResult: .constant(nil), selectedAnnotationId: .constant(storeViewModel.store[1].id))
        StoreAnnotation(profileViewModel: profileViewModel, mapViewModel: mapViewModel, storeItem: storeViewModel.store[2], routeDisplaying: .constant(false), route: .constant(nil), mapCameraPosition: $mapCameraPosition, etaResult: .constant(nil), selectedAnnotationId: .constant(storeViewModel.store[2].id))
        StoreAnnotation(profileViewModel: profileViewModel, mapViewModel: mapViewModel, storeItem: storeViewModel.store[3], routeDisplaying: .constant(false), route: .constant(nil), mapCameraPosition: $mapCameraPosition, etaResult: .constant(nil), selectedAnnotationId: .constant(storeViewModel.store[3].id))
        StoreAnnotation(profileViewModel: profileViewModel, mapViewModel: mapViewModel, storeItem: storeViewModel.store[4], routeDisplaying: .constant(false), route: .constant(nil), mapCameraPosition: $mapCameraPosition, etaResult: .constant(nil), selectedAnnotationId: .constant(storeViewModel.store[4].id))
    }
}*/

//#Preview {
//    @ObservedObject var storeViewModel = StoreViewModel()
//    @ObservedObject var profileViewModel = ProfileViewModel()
//    @ObservedObject var mapViewModel = MapViewModel()
//    
//    return Group {
//        StoreAnnotationV2(
//            // storeViewModel: storeViewModel, profileViewModel: profileViewModel, mapViewModel: mapViewModel,
//            storeItem: storeViewModel.store[0])
//    }
//}

//#Preview {
//    ClusteredAnnotation(cluster: Cluster(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), points: []))
//}
