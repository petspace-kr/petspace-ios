//
//  ProfileEditView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 12/5/23.
//

import SwiftUI

struct ProfileEditView: View {
    
    @Binding var dogProfile: DogProfile
    
    var body: some View {
        VStack {
            Text("ProfileEditView")
            Text(dogProfile.dogName)
        }
        .navigationTitle("프로필 수정")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("저장") {
                    
                }
            }
        }
    }
}

#Preview {
    
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    return Group {
        NavigationStack {
            ProfileEditView(dogProfile: $profileViewModel.dogProfile[0])
        }
    }
}
