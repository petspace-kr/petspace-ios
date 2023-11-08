//
//  StoreData.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/7/23.
//

import Foundation
import CoreLocation

struct Store: Codable {
    var data: Data
    
    struct Data: Codable {
        var items: [StoreItem]
        
        struct StoreItem: Codable, Identifiable {
            var id: String
            var name: String
            var tel: String
            var description: String
            var rating: Double
            var reviewCount: Int
            var iconImage: String
            var images: [String]
            var address: String
            var coordinate: Coordinate
            var pricing: Pricing
            var pricingImage: String
            
            // var createdAt: String
            // var updatedAt: String
            
            // deleted attribute
            var type: String
            // var _id: String
            // var __v: String
            
            struct Coordinate: Codable {
                var longitude: Double
                var latitude: Double
            }
            
            var locationCoordinate: CLLocationCoordinate2D {
                CLLocationCoordinate2D(
                    latitude: coordinate.latitude, longitude: coordinate.longitude
                )
            }
            
            struct Pricing: Codable {
                var cut: Int
            }
            
            var distance: Double?
            var isSaved: Bool?
        }
    }
}
