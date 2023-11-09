//
//  StoreItem.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct StoreItemView: View {
    
    @ObservedObject var mapViewModel: MapViewModel
    @Binding var storeItem: Store.Data.StoreItem
    
    // 프로필 등록 여부
    @State private var isProfile: Bool = false
    
    // 디테일 뷰
    @State private var isDetailViewPresented: Bool = false
    
    // 거리 업데이트 타이머
    @State private var timer: Timer? = nil
    
    var body: some View {
        
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
                    /* if staticMapViewModel.isAuthorized == .authorizedAlways || staticMapViewModel.isAuthorized ==  .authorizedWhenInUse {
                        Text("\(String(format: "%.2f", distanceKM))km")
                            .font(.system(size: 10))
                            .bold()
                            .padding(0)
                    }*/
                    
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
                    .lineLimit(isProfile ? 1 : 3) // 텍스트가 한 줄로 제한
                    .truncationMode(.tail) // 끝에 ... 추가
                
                Spacer()
                    .frame(height: 1)
                
                // 프로필이 등록된 경우
                if isProfile {
                    Menu {
                        Section("프로필을 선택하세요") {
                            Button("\("dog_name") - \("dog_breed")") {
                                // 프로필 변경 코드 작성
                            }
                        }
                        
                    } label: {
                        ZStack(alignment: .leading, content: {
                            RoundedRectangle(cornerRadius: .infinity)
                                .fill(Color("FirstBackground"))
                                .stroke(Color("StrokeColor1"), lineWidth: 1)
                                .frame(height: 35)
                            
                            HStack {
                                // 프로필 이미지 (일단 제거)
                                /* Image("ProfileExample")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 35, height: 35)
                                    .clipShape(Circle()) */
                                
                                Spacer()
                                    .frame(width: 16)
                                
                                VStack(alignment: .leading, content: {
                                    Text("✲ 프로필 맞춤")
                                        .font(.system(size: 10))
                                        .foregroundColor(Color(red: 0, green: 0.64, blue: 1))
                                    Text("커트 \(storeItem.pricing.cut)원~")
                                        .font(.system(size: 10))
                                        .foregroundColor(Color("MainForeground"))
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
        
        // 클릭 시 Detail View 열기
        .onTapGesture {
            isDetailViewPresented = true
        }
        
        // Detail View
        .sheet(isPresented: $isDetailViewPresented, content: {
            DetailView()
        })
        
        // 시작할 때 타이머 시작
        .onAppear() {
            startUpdateLocation()
        }
        
        // 사라질 때 타이머 중지
        .onDisappear() {
            stopUpdateLocation()
        }
    }
    
    func startUpdateLocation() {
        /*distanceKM = calculateDistance(itemCoord: storeData.locationCoordinate, mvCoord: staticMapViewModel.currentRegion.center)
        
        // 5초마다 거리 계산해서 업데이트
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            distanceKM = calculateDistance(itemCoord: storeData.locationCoordinate, mvCoord: staticMapViewModel.currentRegion.center)
        }*/
    }
    
    func stopUpdateLocation() {
        // timer?.fire()
    }
}

#Preview {
    @ObservedObject var mapViewModel = MapViewModel()
    @ObservedObject var storeViewModel = StoreViewModel()
    
    return Group {
        VStack(spacing: 10) {
            StoreItemView(mapViewModel: mapViewModel, storeItem: $storeViewModel.store[0])
            StoreItemView(mapViewModel: mapViewModel, storeItem: $storeViewModel.store[1])
            StoreItemView(mapViewModel: mapViewModel, storeItem: $storeViewModel.store[2])
            StoreItemView(mapViewModel: mapViewModel, storeItem: $storeViewModel.store[3])
            StoreItemView(mapViewModel: mapViewModel, storeItem: $storeViewModel.store[4])
        }
        .padding()
    }
}
