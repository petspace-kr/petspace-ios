//
//  StoreModel.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 10/14/23.
//

import Foundation
import CoreLocation

struct StoreModel: Hashable, Codable, Identifiable {
    var id: String
    var type: String
    var name: String
    var iconImage: String
    var address: String
    var tel: String
    var rating: Double
    var reviewCount: Int
    var description: String
    var images: [String]
    var pricing: Pricing
    
    var coordinate: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude)
    }
    
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
    
    struct Pricing: Hashable, Codable {
        var cut: Int
    }
}

struct JSONData: Codable {
    let data: StoreData
}

struct StoreData: Codable {
    let items: [StoreModel]
}

var jsonData: JSONData = load("dummydata.json")
var storeDatas = jsonData.data.items

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }


    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }


    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

//func loadStoreDatasFromAPI() {
//    if let url = URL(string: "https://petspace.whitekiwi.link:3000/api-app/v1/list-items?breed=푸들&kg=5") {
//        loadFromAPI(url) { (result: Result<JSONData, Error>) in
//            switch result {
//            case .success(let jsonData):
//                let temp = jsonData.data.items
//                print("temp: \(temp[0].name)")
//            case .failure(let error):
//                print("Error loading data: \(error)")
//                // return nil
//            }
//        }
//    }
//}

func loadFromAPI<T: Decodable>(_ url: URL, completion: @escaping (Result<T, Error>) -> Void) {
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            completion(.success(decodedData))
        } catch {
            completion(.failure(error))
        }
    }
    task.resume()
}

import SwiftUI

struct TestView: View {
    var body: some View {
        Text(storeDatas[0].name)
    }
}

#Preview {
    TestView()
}
