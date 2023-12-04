//
//  ProfileViewModel.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    
    // 프로필 리스트
    @Published var dogProfile: [DogProfile] = []
    
    // 현재 화면에서 선택된 프로필 인덱스
    @Published var selectedProfileIndex: Int = -1
    
    init() {
        addDummyData()
        // loadProfile()
    }
    
    func addDummyData() {
        if let url = Bundle.main.url(forResource: "dummyprofile", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                var profile = try decoder.decode(DogProfile.self, from: data)
                
                if profile.id == nil {
                    profile.id = UUID()
                }
                
                self.dogProfile = [profile]
                selectedProfileIndex = 0
            } catch {
                print("Error while decoding JSON: \(error)")
            }
        }
    }
    
    func loadProfile() {
        if let savedProfilesData = UserDefaults.standard.data(forKey: "dogProfileData") {
            if let savedProfile = try? JSONDecoder().decode([DogProfile].self, from: savedProfilesData) {
                dogProfile = savedProfile
                
                if dogProfile.count > 0 {
                    selectedProfileIndex = 0
                }
                print("\(dogProfile.count) profiles loaded. selected Profile Index: \(selectedProfileIndex)")
                return
            }
        }
        
        dogProfile = []
        print("profile load failed. because there is no saved profile data.")
    }
    
    func addProfile(dogName: String, dogBreed: String, dogSize: DogSize, dogWeight: Double, profileImage: UIImage?) {
        print("addProfile()")
        dogProfile.append(DogProfile(dogName: dogName, dogBreed: dogBreed, dogSize: dogSize, dogWeight: dogWeight, profileImage: profileImage))
        
        print("appended")
        // 선택된 프로필 인덱스, 맨 마지막으로
        selectedProfileIndex = dogProfile.count - 1
        
        print("selectedProfileIndex changed to \(selectedProfileIndex)")
        saveProfile()
        
        print("new profile data created. now num of profiles: \(dogProfile.count) and index is \(selectedProfileIndex)")
    }
    
    func updateProfile(index: Int, dogName: String, dogBreed: String, dogSize: DogSize, dogWeight: Double, profileImage: UIImage?) {
        dogProfile[index].dogName = dogName
        dogProfile[index].dogBreed = dogBreed
        dogProfile[index].dogSize = dogSize
        dogProfile[index].dogWeight = dogWeight
        
        if let profileImage = profileImage {
            if let imageData = profileImage.encodeToData() {
                dogProfile[index].profileImageData = imageData
            }
        }
        saveProfile()
        print("profile #\(index) updated. now num of profiles: \(dogProfile.count) and index is \(selectedProfileIndex)")
    }
    
    func saveProfile() {
        if let encodedProfile = try? JSONEncoder().encode(dogProfile) {
            UserDefaults.standard.setValue(encodedProfile, forKey: "dogProfileData")
            print("profile data saved in UserDefaults")
        } else {
            print("profile data save failed")
        }
    }
    
    func resetAllProfile() {
        dogProfile.removeAll()
        dogProfile = []
        selectedProfileIndex = -1
        
        // 삭제된 데이터를 로컬 저장소에 저장
        saveProfile()
    }
}

struct DogProfile: Identifiable, Codable {
    var id: UUID?
    var dogName: String
    var dogBreed: String
    var dogSize: DogSize
    var dogWeight: Double
    var profileImageData: Data?
    // var birthday: Date?
    
    init(dogName: String, dogBreed: String, dogSize: DogSize, dogWeight: Double) {
        self.id = UUID()
        self.dogName = dogName
        self.dogBreed = dogBreed
        self.dogSize = dogSize
        self.dogWeight = dogWeight
        self.profileImageData = nil
    }
    
    init(dogName: String, dogBreed: String, dogSize: DogSize, dogWeight: Double, profileImage: UIImage?) {
        self.id = UUID()
        self.dogName = dogName
        self.dogBreed = dogBreed
        self.dogSize = dogSize
        self.dogWeight = dogWeight
        
        if let profileImage = profileImage {
            if let imageData = profileImage.encodeToData() {
                self.profileImageData = imageData
            }
        }
    }
}

enum DogSize: Int, Codable {
    case unknown = -1
    case small = 0
    case medium = 1
    case large = 2
}

struct ProfileTestView: View {
    
    @ObservedObject var profileViewModel: ProfileViewModel
    
    @State private var name: String = ""
    @State private var breed: String = ""
    @State private var weight: String = ""
    
    @State private var currentIndex: Int = 0
    
    var body: some View {
        VStack {
            Text("Number of Profiles: \(profileViewModel.dogProfile.count)")
                .font(.title2)
                .bold()
            
            Button("Save Profile Data") {
                profileViewModel.saveProfile()
            }
            .buttonStyle(.borderedProminent)
            
            Button("Load Profile Data") {
                profileViewModel.loadProfile()
            }
            .buttonStyle(.borderedProminent)
            
            Spacer().frame(height: 30)
            
            Text("Profile Test, current idx: \(currentIndex)")
                .font(.title3)
                .bold()
            
            GroupBox {
                TextField("name", text: $name)
            }
            
            GroupBox {
                TextField("breed", text: $breed)
            }
            
            GroupBox {
                TextField("weight", text: $weight)
                    .keyboardType(.decimalPad)
            }
            
            HStack {
                Button("Add Profile") {
                    profileViewModel.addProfile(dogName: name, dogBreed: breed, dogSize: .small, dogWeight: 10.0, profileImage: nil)
                }
                .buttonStyle(.borderedProminent)
                .disabled(name == "" || breed == "" || weight == "")
                
                Button("Update Profile") {
                    profileViewModel.updateProfile(index: currentIndex, dogName: name, dogBreed: breed, dogSize: .small, dogWeight: 10.0, profileImage: nil)
                }
                .buttonStyle(.borderedProminent)
                .disabled(name == "" || breed == "" || weight == "")
                
                Button("Reset") {
                    profileViewModel.resetAllProfile()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            
            Spacer()
                .frame(height: 30)
            
            if (profileViewModel.dogProfile.isEmpty) {
                Text("No Profile Data Found.")
            } else {
                List {
                    ForEach(Array(profileViewModel.dogProfile.enumerated()), id: \.offset) { index, profile in
                        Button("\(index). \(profile.dogName), \(profile.dogBreed), \(profile.dogWeight)") {
                            currentIndex = index
                            name = profile.dogName
                            breed = profile.dogBreed
                            weight = "\(profile.dogWeight)"
                        }
                    }
                }
                .listStyle(.plain)
                .padding(0)
            }
        }
        .padding()
    }
}

#Preview {
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    return Group {
        ProfileTestView(profileViewModel: profileViewModel)
    }
}

extension UIImage {
    func encodeToData() -> Data? {
        return self.jpegData(compressionQuality: 1.0)
    }
}

extension Data {
    func decodeToImage() -> UIImage? {
        return UIImage(data: self)
    }
}
