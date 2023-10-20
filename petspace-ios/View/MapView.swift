//
//  MapView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 10/14/23.
//

import SwiftUI
import CoreLocation
import MapKit

struct MapView: View {
    
    var coordinate: CLLocationCoordinate2D
    
    @Environment(StoreDatas.self) var storeDatas
    @StateObject private var mapViewModel = MapViewModel()
    
    var body: some View {
        Map(initialPosition: MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.484_902, longitude: 127.041_819), span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)))) {
            
            ForEach(storeDatas.items) { storeData in
                Annotation(storeData.name, coordinate: CLLocationCoordinate2D(latitude: storeData.coordinate.latitude, longitude: storeData.coordinate.longitude)) {
                    
                    VStack(spacing: 5) {
                        // 이미지
                        AsyncImage(url: URL(string: storeData.iconImage)) { image in
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
                        
                        // 가격 및 별점
                        HStack {
                            if storeData.rating < 0 {
                                Text("\(storeData.pricing.cut) ~")
                                  .font(Font.custom("SF Pro Text", size: 11))
                                  .foregroundColor(.white)
                                  .padding(.leading, 6)
                                  .padding(.trailing, 6)
                            } else {
                                Text("✦ \(String(format: "%.1f", storeData.rating)) ∙ \(storeData.pricing.cut) ~")
                                  .font(Font.custom("SF Pro Text", size: 11))
                                  .foregroundColor(.white)
                                  .padding(.leading, 6)
                                  .padding(.trailing, 6)
                            }
                            
                        }
                        .foregroundColor(.clear)
                        .frame(height: 20)
                        .background(Color(red: 0, green: 0.64, blue: 1).opacity(0.6))
                        .cornerRadius(21)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onAppear() {
            mapViewModel.checkIfLocationServicesIsEnabled()
        }
        .mapStyle(.standard)
        .mapControls {
//            MapCompass()
//            MapPitchToggle()
//            MapUserLocationButton()
        }
    }
}

#Preview {
    MapView(coordinate: CLLocationCoordinate2D(latitude: 37.0, longitude: 127.0))
        .environment(StoreDatas())
}
