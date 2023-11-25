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
    let mapCameraBounds: MapCameraBounds = MapCameraBounds(minimumDistance: 1200,
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
    
    // Store Preview
    @State var isPreviewPresented: Bool = false
    @State var selectedStore: Store.Data.StoreItem?
    
    // Sheet selection
    @State private var detentSelection: PresentationDetent = .fraction(0.3)
    
    var body: some View {
        Map(position: $mapCameraPosition, bounds: mapCameraBounds) {
        // Map(initialPosition: .camera(mapCamera), bounds: mapCameraBounds) {
            UserAnnotation()
            
            // 확대된 경우 전부 표시
            if lastDistance < 40000 {
                ForEach(storeViewModel.store) { storeItem in
                    Annotation(storeItem.name, coordinate: CLLocationCoordinate2D(latitude: storeItem.coordinate.latitude, longitude: storeItem.coordinate.longitude)) {
                        StoreAnnotationV2(storeItem: storeItem, mapCameraPosition: $mapCameraPosition, isPreviewPresented: $isPreviewPresented, selectedStore: $selectedStore)
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
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
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
            
        }, content: {
            if let selectedStore = selectedStore {
                StorePreviewView(store: selectedStore)
                    .presentationDetents([.fraction(0.3), .large], selection: $detentSelection)
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(30.0)
                    .presentationBackgroundInteraction(.enabled)
            } else {
                ProgressView()
                    .presentationDetents([.fraction(0.3), .large], selection: $detentSelection)
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

#Preview {
    @ObservedObject var storeViewModel = StoreViewModel()
    @ObservedObject var mapViewModel = MapViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    return Group {
        MapOneView(storeItem: storeViewModel.store[0], mapViewModel: mapViewModel, profileViewModel: profileViewModel)
            .padding(10)
    }
}

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
            print(storeItem.name)
            print(storeItem.locationCoordinate)
            withAnimation(.spring()) {
                mapCameraPosition = .camera(MapCamera(centerCoordinate: storeItem.locationCoordinate, distance: 2000, heading: 0, pitch: 0))
            }
            selectedStore = storeItem
            
            if selectedStore != nil {
                isPreviewPresented = true
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
                .frame(width: 30, height: 30)
                .shadow(radius: 5)
            
            Circle()
                // .stroke(Color.white, lineWidth: 5)
                .fill(Color(red: 0, green: 0.64, blue: 1).opacity(0.3 + 0.05 * Double(min(cluster.points.count, 10))))
                .frame(width: 24, height: 24)
            
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
