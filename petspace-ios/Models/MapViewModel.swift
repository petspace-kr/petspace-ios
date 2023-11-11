//
//  MapViewModel.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/7/23.
//

import CoreLocation
import MapKit

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    private var timer: Timer?
    
    @Published var isLocationServiceEnabled: Bool = false
    @Published var isAuthorized: CLAuthorizationStatus = .notDetermined
    // @Published var isAccuracyAuthorized: CLAccuracyAuthorization? = nil
    
    @Published var startRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.489_902, longitude: 127.041_819), span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
    @Published var currentRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.489_902, longitude: 127.041_819), span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
    
    // Span
    @Published var mapSpan: CLLocationDegrees = 0.07
    
    @Published var isTimerRunning: Bool = false
    
    func checkLocationServiceEnabled() {
        
        print("CLLocationManager.locationServiceEnabled: \(CLLocationManager.locationServicesEnabled())")
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            isLocationServiceEnabled = true
        }
        
        // now allowed
        else {
            isLocationServiceEnabled = false
        }
    }
    
    private func checkLocationAuthorization() {
        
        guard let locationManager = locationManager else { return }
        
        print("location manager status: \(locationManager.authorizationStatus)")
        isAuthorized = locationManager.authorizationStatus
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            print("not determined")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("restriced")
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("denied")
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            print("allowed")
            currentRegion = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
            break
        @unknown default:
            break
        }
        
        isAuthorized = locationManager.authorizationStatus
        print("isAuthored: \(isAuthorized)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func startTimer() {
        if !isTimerRunning {
            print("timer started")
            self.updateUserLocation()
            
            // 2초마다 GPS 위치 정보 업데이트
            timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                if self.isTimerRunning {
                    self.updateUserLocation()
                }
            }
            isTimerRunning = true
        } else {
            print("Timer is already running, so not started")
        }
    }
    
    func fireTimer() {
        if isTimerRunning && timer != nil {
            print("timer is fired")
            timer!.fire()
            isTimerRunning = false
        } else {
            print("timer is not running, so not fired")
        }
    }
    
    func updateUserLocation() {
        if let locationManager = locationManager {
            if let location = locationManager.location {
                currentRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
                print("updated: \(currentRegion.center.latitude), \(currentRegion.center.longitude)")
            }
            else {
                print("locationManager.location is nil")
            }
        }
        else {
            print("locationManager is nil")
        }
    }
}
