//
//  DogBreedData.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/7/23.
//

import Foundation

// 개의 견종을 포함하는 데이터 타입
struct DogBreed: Codable {
    var small: [Dog]
    var medium: [Dog]
    var large: [Dog]
}

struct Dog: Codable {
    var name: String
}

// JSON 파일을 읽어 Struct Instance 생성
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
