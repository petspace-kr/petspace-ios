//
//  ProfileViewModel.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var dogProfile: DogProfile
    
    init(dogName: String, dogBreed: String, dogSize: Int, dogWeight: Double) {
        dogProfile = DogProfile(dogName: dogName, dogBreed: dogBreed, dogSize: dogSize, dogWeight: dogWeight)
    }
    
    init() {
        dogProfile = DogProfile(dogName: "", dogBreed: "", dogSize: 0, dogWeight: 0.0)
    }
}

struct DogProfile {
    var dogName: String
    var dogBreed: String
    var dogSize: Int
    var dogWeight: Double
    var profileImage: UIImage?
    // var birthday: Date?
}
