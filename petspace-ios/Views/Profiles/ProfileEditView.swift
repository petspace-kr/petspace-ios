//
//  ProfileEditView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 12/5/23.
//

import SwiftUI

struct ProfileEditView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var profileViewModel: ProfileViewModel
    @Binding var selectedIndex: Int
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Profile Edit View")
                
                if selectedIndex >= 0 {
                    Text(profileViewModel.dogProfile[selectedIndex].dogName)
                } else {
                    ProgressView()
                }
                
            }
            .navigationTitle("프로필 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Label("프로필", systemImage: "chevron.left")
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("저장") {
                        dismiss()
                    }
                    .disabled(true)
                }
            }
        }
    }
}

#Preview {
    
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    return Group {
        NavigationStack {
            ProfileEditView(profileViewModel: profileViewModel, selectedIndex: .constant(0))
        }
    }
}
