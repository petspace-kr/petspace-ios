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
    @Published var isProfileRegistered: Bool
    
    init(dogName: String, dogBreed: String, dogSize: DogSize, dogWeight: Double) {
        dogProfile = DogProfile(dogName: dogName, dogBreed: dogBreed, dogSize: dogSize, dogWeight: dogWeight)
        isProfileRegistered = true
    }
    
    init() {
        dogProfile = DogProfile(dogName: "", dogBreed: "", dogSize: .unknown, dogWeight: 0.0)
        isProfileRegistered = false
    }
    
    func updateProfile(dogName: String, dogBreed: String, dogSize: DogSize, dogWeight: Double) {
        
        dogProfile.dogName = dogName
        dogProfile.dogBreed = dogBreed
        dogProfile.dogSize = dogSize
        dogProfile.dogWeight = dogWeight
        
        isProfileRegistered = true
        saveProfile()
    }
    
    func updateProfileImage(image: UIImage) {
        dogProfile.profileImage = image
    }
    
    func saveProfile() {
        // UserDefault에 프로필 데이터 저장
    }
}

struct DogProfile {
    var dogName: String
    var dogBreed: String
    var dogSize: DogSize
    var dogWeight: Double
    var profileImage: UIImage?
    // var birthday: Date?
}

enum DogSize: Int {
    case unknown = -1
    case small = 0
    case medium = 1
    case large = 2
}
