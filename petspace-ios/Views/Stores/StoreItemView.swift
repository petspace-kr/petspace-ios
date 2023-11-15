//
//  StoreItem.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct StoreItemView: View {
    
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @State var storeItem: Store.Data.StoreItem
    
    // 디테일 뷰
    @State private var isDetailViewPresented: Bool = false
    
    // 거리 업데이트 타이머
    @State private var timer: Timer? = nil
    
    // 계산된 거리 저장 변수
    @State private var distanceKM: Double = 0.0
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(Color("Background1"))
                .stroke(Color("Stroke1"), lineWidth: 1)
            
            HStack(alignment: .center, content: {
                // Store Main Image
                AsyncImage(url: URL(string: storeItem.iconImage)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 97, height: 113)
                    .background(Color.gray)
                    .cornerRadius(18)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4.0, content: {
                    HStack {
                        // Store Title
                        Text(storeItem.name)
                            .font(.system(size: 15))
                            .bold()
                        
                        Spacer()
                    }
                    
                    // Store Address
                    Text(storeItem.address)
                        .font(.system(size: 12))
                
                    // Store Score and Number of Reviews
                    HStack {
                        // 위치 정보 허용된 경우 거리 표시
                        if (mapViewModel.isAuthorized == .authorizedAlways || mapViewModel.isAuthorized == .authorizedWhenInUse) && (mapViewModel.userLatitude != 0.0 && mapViewModel.userLongitude != 0.0) {
                            // Text("\(String(format: "%.2f", distanceKM))km")
                            Text("\(String(format: "%.2f", Coordinate(latitude: mapViewModel.userLatitude, longitude: mapViewModel.userLongitude).distance(to: Coordinate(latitude: storeItem.coordinate.latitude, longitude: storeItem.coordinate.longitude))))km")
                                .font(.system(size: 10))
                                .bold()
                                .padding(0)
                        }
                        
                        if storeItem.rating < 0 {
                            Text("리뷰 \(storeItem.reviewCount)개")
                                .font(.system(size: 10))
                                .padding(0)
                        }
                        else {
                            Text("✦ \(String(format: "%.1f", storeItem.rating)) ∙ 리뷰 \(storeItem.reviewCount)개")
                                .font(.system(size: 10))
                                .padding(0)
                        }
                    }
                    
                    // Store Description
                    Text(storeItem.description)
                        .font(.system(size: 10))
                        .foregroundStyle(.gray)
                        .lineLimit(profileViewModel.dogProfile.isEmpty ? 3 : 1) // 텍스트가 한 줄로 제한
                        .truncationMode(.tail) // 끝에 ... 추가
                    
                    Spacer()
                        .frame(height: 1)
                    
                    // 프로필이 등록된 경우
                    if !profileViewModel.dogProfile.isEmpty {
                        Menu {
                            Section("프로필을 선택하세요") {
                                ForEach (Array(profileViewModel.dogProfile.enumerated()), id: \.offset) { index, profile in
                                    Button("\(profile.dogName) - \(profile.dogBreed)") {
                                        // 프로필 변경 코드 작성
                                        profileViewModel.selectedProfileIndex = index
                                    }
                                }
                            }
                            
                        } label: {
                            ZStack(alignment: .leading, content: {
                                RoundedRectangle(cornerRadius: .infinity)
                                    .fill(Color("Background2"))
                                    .stroke(Color("Stroke1"), lineWidth: 1)
                                    .frame(height: 35)
                                
                                HStack {
                                    // 프로필 이미지
                                    if let imageData = profileViewModel.dogProfile[profileViewModel.selectedProfileIndex].profileImageData {
                                        if let image = imageData.decodeToImage() {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 35, height: 35)
                                                .clipShape(Circle())
                                        } else {
                                            Spacer()
                                                .frame(width: 16)
                                        }
                                    } else {
                                        Spacer()
                                            .frame(width: 16)
                                    }
                                    
                                    VStack(alignment: .leading, content: {
                                        Text("✲ 프로필 맞춤")
                                            .font(.system(size: 10))
                                            .foregroundColor(Color(red: 0, green: 0.64, blue: 1))
                                            .fixedSize(horizontal: true, vertical: true)
                                        Text("커트 \(storeItem.pricing.cut)원~")
                                            .font(.system(size: 10))
                                            .foregroundColor(.primary)
                                            .fixedSize(horizontal: true, vertical: true)
                                    })
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 10)
                                }
                            })
                        }
                    }
                })
            })
            .padding(10)
            
            // 클릭 시 Detail View 열기
            .onTapGesture {
                isDetailViewPresented = true
            }
            
            // Detail View
            .sheet(isPresented: $isDetailViewPresented, onDismiss: {
                GATracking.sendLogEvent(eventName: GATracking.MainViewMessage.STORE_DETAIL_CLOSE, params: nil)
            }, content: {
                DetailView(storeItem: storeItem, isPresented: $isDetailViewPresented, profileViewModel: profileViewModel, mapViewModel: mapViewModel)
                    .onAppear() {
                        GATracking.sendLogEvent(eventName: GATracking.MainViewMessage.STORE_DETAIL_OPEN, params: nil)
                    }
            })
            
            // 시작할 때 타이머 시작
            .onAppear() {
                // startUpdateLocation()
            }
            
            // 사라질 때 타이머 중지
            .onDisappear() {
                // stopUpdateLocation()
            }
        }
        
        
    }
    
    func startUpdateLocation() {
        distanceKM = calculateDistance(itemCoord: storeItem.locationCoordinate, mvCoord: mapViewModel.currentRegion.center)
        
        // 5초마다 거리 계산해서 업데이트
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            distanceKM = calculateDistance(itemCoord: storeItem.locationCoordinate, mvCoord: mapViewModel.currentRegion.center)
            print("storeItem \(storeItem.id) updated: \(distanceKM)")
        }
    }
    
    func stopUpdateLocation() {
        timer?.fire()
    }
}

#Preview {
    @ObservedObject var mapViewModel = MapViewModel()
    @ObservedObject var storeViewModel = StoreViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    return Group {
        VStack(spacing: 10) {
            StoreItemView(mapViewModel: mapViewModel, profileViewModel: profileViewModel, storeItem: storeViewModel.store[0])
            StoreItemView(mapViewModel: mapViewModel, profileViewModel: profileViewModel, storeItem: storeViewModel.store[1])
            StoreItemView(mapViewModel: mapViewModel, profileViewModel: profileViewModel, storeItem: storeViewModel.store[2])
            StoreItemView(mapViewModel: mapViewModel, profileViewModel: profileViewModel, storeItem: storeViewModel.store[3])
            StoreItemView(mapViewModel: mapViewModel, profileViewModel: profileViewModel, storeItem: storeViewModel.store[4])
        }
        .padding()
    }
}
