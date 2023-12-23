//
//  ProfileListView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 12/5/23.
//

import SwiftUI

struct ProfileListView: View {
    
    @ObservedObject var profileViewModel: ProfileViewModel
    @State private var isProfileAddViewPresented: Bool = false
    @State private var isProfileEditViewPresented: Bool = false
    @State private var selectedIndex: Int = -1
    
    private let dogSizeString: [String] = ["소형견", "중형견", "대형견"]
    
    // 삭제 여부 모달
    @State private var isDeleteModalShowing: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("프로필")
                        .font(.title)
                        .bold()
                    
                    Spacer()
                    
                    Button("추가") {
                        isProfileAddViewPresented = true
                    }
                    .padding(.trailing, 6)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            .navigationTitle("프로필")
            .navigationBarHidden(true)
            
            Spacer()
                .frame(height: 10)
            
            if (!profileViewModel.dogProfile.isEmpty) {
                Text("스와이프해서 수정 또는 삭제할 수 있어요")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            
            if (profileViewModel.dogProfile.isEmpty) {
                Spacer()
                
                Text("프로필이 없어요. \n추가 버튼을 눌러 프로필을 추가해보세요.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    
                Spacer()
                    .frame(height: 30)
                
                Spacer()
            } else {
                List {
                    ForEach(Array(profileViewModel.dogProfile.enumerated()), id: \.offset) { index, profile in
                        // ProfileCardView(dogProfile: profile, profileViewModel: profileViewModel, index: index)
                        ZStack {
                            RoundedRectangle(cornerRadius: 30.0)
                                .fill(Color("Background1"))
                                .stroke(profileViewModel.selectedProfileIndex == index ? .gray : Color("Stroke1"), lineWidth: 1)
                                .frame(height: 100)
                                
                            HStack(alignment: .center) {
                                if let imageData = profile.profileImageData {
                                    if let image = imageData.decodeToImage() {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipShape(Circle())
                                    } else {
                                        Circle()
                                            .foregroundColor(Color("Stroke1"))
                                            .frame(width: 80, height: 80)
                                    }
                                } else {
                                    Circle()
                                        .foregroundColor(Color("Stroke1"))
                                        .frame(width: 80, height: 80)
                                }
                                
                                Spacer()
                                    .frame(width: 10)
                                
                                VStack(alignment: .leading) {
                                    Text(profile.dogName)
                                        .font(.title3)
                                        .bold()
                                    
                                    Text("\(profile.dogBreed)(\(dogSizeString[profile.dogSize.rawValue]))")
                                    Text("\(String(format: "%.1f", profile.dogWeight))kg")
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 14)
                        }
                        .listRowSeparator(.hidden)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                // TODO: edit indexing
                                selectedIndex = index
                                isProfileEditViewPresented = true
                            } label: {
                                Label("수정", systemImage: "pencil")
                            }
                            .tint(.gray)
                            
                            Button(role: .destructive) {
                                // TODO: edit indexing
                                selectedIndex = index
                                isDeleteModalShowing = true
                            } label: {
                                Label("삭제", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                profileViewModel.selectedProfileIndex = index
                            }
                            print("profileViewModel sIndex: \(index)")
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        
        // Add View
        .sheet(isPresented: $isProfileAddViewPresented, onDismiss: {
            
        }, content: {
            ProfileAddView(isPresented: $isProfileAddViewPresented, profileViewModel: profileViewModel)
                // .interactiveDismissDisabled(true)
        })
        
        // Edit View
        .sheet(isPresented: $isProfileEditViewPresented, onDismiss: {
            selectedIndex = -1
        }, content: {
            ProfileEditView(isPresented: $isProfileEditViewPresented, profileViewModel: profileViewModel, selectedIndex: $selectedIndex)
                // .interactiveDismissDisabled(true)
        })
        
        // 삭제 모달
        // 견종 크기 안내
        .alert("프로필 삭제", isPresented: $isDeleteModalShowing, actions: {
            Button("취소", role: .cancel) {
                selectedIndex = -1
            }
            Button("삭제", role: .destructive) {
                if selectedIndex >= 0 {
                    profileViewModel.deleteProfile(index: selectedIndex)
                    selectedIndex = -1
                }
            }
            .disabled(selectedIndex < 0)
        }, message: {
            if selectedIndex >= 0 {
                Text("\(profileViewModel.dogProfile[selectedIndex].dogName)의 프로필 데이터를 삭제할까요? 프로필은 앱에만 저장되므로 삭제 후 되돌릴 수 없어요.")
            } else {
                ProgressView()
            }
        })
    }
}

#Preview {
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    return Group {
        ProfileListView(profileViewModel: profileViewModel)
    }
}
