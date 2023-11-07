//
//  DogBreedData.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/7/23.
//

import SwiftUI
import Foundation

struct DogBreed: Codable {
    var small: [Dog]
    var medium: [Dog]
    var large: [Dog]
}

struct Dog: Codable {
    var name: String
}

// var dogBreeds: DogBreed = load("dogbreed.json")

