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
        MapView(storeViewModel: storeViewModel, mapViewModel: mapViewModel, profileViewModel: profileViewModel)
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
            .sheet(isPresented: $isDetailViewPresented, onDismiss: {
                
            }, content: {
                DetailView(storeItem: storeItem, isPresented: $isDetailViewPresented, profileViewModel: profileViewModel, mapViewModel: mapViewModel)
                    .presentationDragIndicator(.visible)
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
                            Button {
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
                            .disabled(mapViewModel.userLatitude == 0.0 || mapViewModel.userLongitude == 0.0)
                            
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
                        if storeItem.rating < 0 {
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

#Preview {
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
}
