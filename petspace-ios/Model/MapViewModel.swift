//
//  MapViewModel.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 10/14/23.
//

import SwiftUI
import CoreLocation
import MapKit

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var startRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.489_902, longitude: 127.041_819), span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
    @Published var currentRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.489_902, longitude: 127.041_819), span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            // locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            // checkLocationAuthorization()
        } else {
            //
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedAlways, .authorizedWhenInUse:
            currentRegion = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
            break
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
