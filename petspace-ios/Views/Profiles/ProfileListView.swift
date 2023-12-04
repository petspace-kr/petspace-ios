//
//  ProfileListView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 12/5/23.
//

import SwiftUI

struct ProfileListView: View {
    
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        NavigationStack {
            if (profileViewModel.dogProfile.isEmpty) {
                VStack {
                    HStack {
                        Text("프로필")
                            .font(.title)
                            .bold()
                        
                        Spacer()
                        
                        Button("추가") {
                            
                        }
                        .padding(.trailing, 6)
                    }
                    
                    Spacer()
                    
                    Text("프로필이 없어요. 새로운 프로필을 추가해보세요.")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                .navigationTitle("프로필")
                .navigationBarHidden(true)
            } else {
                VStack {
                    HStack {
                        Text("프로필")
                            .font(.title)
                            .bold()
                        
                        Spacer()
                        
                        Button("추가") {
                            
                        }
                        .padding(.trailing, 6)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                List {
                    ForEach(Array(profileViewModel.dogProfile.enumerated()), id: \.offset) { index, profile in
                        ProfileCardView(dogProfile: profile)
                            .listRowSeparator(.hidden)
                            .background(
                                NavigationLink("", destination: ProfileEditView(dogProfile: $profileViewModel.dogProfile[index]))
                                    .opacity(0)
                            )
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    
                                } label: {
                                    Label("삭제", systemImage: "trash")
                                }
                                .tint(.red)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    
                                } label: {
                                    Label("편집", systemImage: "pencil")
                                }
                                .tint(.gray)
                            }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("프로필")
                .navigationBarHidden(true)
            }
        }
    }
}

struct ProfileCardView: View {
    
    @State var dogProfile: DogProfile
    
    let dogSizeTextArray = ["소형견", "중형견", "대형견"]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30.0)
                .fill(Color("Background1"))
                .stroke(Color("Stroke1"), lineWidth: 1)
                .frame(height: 100)
                
            HStack(alignment: .center) {
                if let imageData = dogProfile.profileImageData {
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
                    Text(dogProfile.dogName)
                        .font(.title3)
                        .bold()
                    
                    Text("\(dogProfile.dogBreed)(\(dogSizeTextArray[dogProfile.dogSize.rawValue]))")
                    Text("\(String(format: "%.1f", dogProfile.dogWeight))kg")
                }
                
                Spacer()
            }
            .padding(.horizontal, 14)
        }
    }
}

#Preview {
    return Group {
        ProfileListView(profileViewModel: ProfileViewModel())
    }
}
