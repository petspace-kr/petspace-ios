//
//  StoreListView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct StoreListView: View {
    
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var storeViewModel: StoreViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    // 정렬 방식
    private enum SortMode: String {
        case distance = "거리순"
        case rating = "별점순"
        case priceIncrease = "가격낮은순"
        case priceDecrease = "가격높은순"
    }
    @State private var sortMode: SortMode = .distance
    
    // 드래그 뷰 관련 변수
    @State private var viewHeight: CGFloat = UIScreen.main.bounds.height * 0.5
    
    // 스크린 종류
    private enum ScreenMode: CGFloat {
        case fullScreen = 1.0
        case half = 0.5
        case hidden = 0.1
    }
    @State private var screenMode: ScreenMode = .half
    
    // 프로필 등록 여부
    @State private var isProfile: Bool = false
    
    // 프로필 뷰 Presented
    @State private var isProfileViewPresented: Bool = false
    
    // 검색
    @State private var isSearching: Bool = false
    @State private var searchText: String = ""
    
    // 필터링 된 Store List
    @State private var filteredStoreItems: [Store.Data.StoreItem] = []
    
    // 저장된 Store 보여주는 여부
    @State private var isSavedStoreShowing: Bool = false
    
    var body: some View {
        NavigationStack(root: {
            VStack {
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 36, height: 5)
                  .background(Color.gray)
                  .cornerRadius(2.5)
                
                HStack {
                    Text("강남구 애견미용실")
                        .font(.headline)
                        .bold()
                        .padding(.leading, 10)
                    
                    Spacer()
                    
                    // 숨기기 버튼 보이기
                    /* Button("Hide") {
                        hideView()
                    } */
                    
                    // 검색 중 아닌 경우 검색 버튼 보이기
                    if !isSearching {
                        Button("검색") {
                            withAnimation(.spring, {
                                isSearching = true
                                // 검색 시 전체화면으로 전환
                                viewHeight = UIScreen.main.bounds.height * ScreenMode.fullScreen.rawValue
                                screenMode = .fullScreen
                            })
                        }
                    }
                    
                    Spacer()
                        .frame(width: 12)
                    
                    // 정렬 방식 선택 메뉴
                    Menu("\(sortMode.rawValue)") {
                        Section("정렬 방식을 선택하세요") {
                            // 가격 순
                            Button(SortMode.distance.rawValue, systemImage: "map") {
                                sortMode = .distance
                            }
                            
                            // 별점 순
                            Button(SortMode.rating.rawValue, systemImage: "star") {
                                sortMode = .rating
                            }
                            
                            // 가격 낮은 순
                            Button(SortMode.priceIncrease.rawValue, systemImage: "line.3.horizontal.decrease") {
                                sortMode = .priceIncrease
                            }
                            .disabled(!isProfile)
                            
                            // 가격 높은 순
                            Button(SortMode.priceDecrease.rawValue, systemImage: "line.3.horizontal.decrease") {
                                sortMode = .priceDecrease
                            }
                            .disabled(!isProfile)
                        }
                    }
                    .padding(.trailing, 6)
                }
                .padding(.top, 4)
                .padding(.bottom, 10)
                
                // 프로필 등록된 경우
                if !isProfile {
                    HStack {
                        Button {
                            isProfileViewPresented = true
                        } label: {
                            Text("프로필을 등록하면")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                                // .padding(.vertical, 10)
                                .multilineTextAlignment(.center)
                                .padding(0)
                        }
                        .padding(.trailing, -2)
                        Text("맞춤형 가격을 바로 확인할 수 있어요")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                            // .padding(.vertical, 10)
                            .multilineTextAlignment(.center)
                            .padding(.leading, -2)
                    }
                    .sheet(isPresented: $isProfileViewPresented, content: {
                        ProfileView()
                    })
                }
                
                // 검색 중인 경우 검색바 표시
                if isSearching {
                    SearchBar(text: $searchText, isEditing: $isSearching)
                }
                
                ScrollView(showsIndicators: false, content: {

                    if isSearching && !searchText.isEmpty {
                        let filteredStoreItems = storeViewModel.store.filter({ searchModel(textArray: [$0.name, $0.address, $0.description], keyword: searchText) && checkIsSaved(isSaved: $0.isSaved) })
                        
                        if filteredStoreItems.isEmpty {
                            Text("검색 결과가 없어요.\n다른 검색어를 입력해보세요.")
                                .font(.system(size: 15))
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.top, 5)
                        }
                        
                        // 거리 순 정렬
                        else if sortMode == .distance {
                            ForEach(filteredStoreItems.sorted(by: { calculateDistance(itemCoord: $0.locationCoordinate, mvCoord: mapViewModel.currentRegion.center) < calculateDistance(itemCoord: $1.locationCoordinate, mvCoord: mapViewModel.currentRegion.center) })) { storeItem in
                                StoreItemView(mapViewModel: mapViewModel, profileViewModel: profileViewModel, storeItem: storeItem)
                                    .padding(.bottom, 10)
                            }
                        }
                        
                        // 별점 순 정렬
                        else if sortMode == .rating {
                            ForEach(filteredStoreItems.sorted(by: { $0.rating > $1.rating })) { storeItem in
                                StoreItemView(mapViewModel: mapViewModel, profileViewModel: profileViewModel, storeItem: storeItem)
                            }
                        }
                        
                        // 가격 낮은 순
                        else if sortMode == .priceIncrease {
                            ForEach(filteredStoreItems.sorted(by: { $0.pricing.cut < $1.pricing.cut })) { storeItem in
                                StoreItemView(mapViewModel: mapViewModel, profileViewModel: profileViewModel, storeItem: storeItem)
                            }
                        }
                        
                        // 가격 높은 순
                        else if sortMode == .priceDecrease {
                            ForEach(filteredStoreItems.sorted(by: { $0.pricing.cut > $1.pricing.cut })) { storeItem in
                                StoreItemView(mapViewModel: mapViewModel, profileViewModel: profileViewModel, storeItem: storeItem)
                            }
                        }
                    }
                    else {
                        let filteredStoreItems = storeViewModel.store.filter({ checkIsSaved(isSaved: $0.isSaved) })
                        
                        if filteredStoreItems.isEmpty {
                            Text("저장된 미용실이 없어요.\n마음에 드는 미용실을 저장해보세요.")
                                .font(.system(size: 15))
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.top, 5)
                        }
                        
                        // 거리 순 정렬
                        else if sortMode == .distance {
                            ForEach(filteredStoreItems.sorted(by: { calculateDistance(itemCoord: $0.locationCoordinate, mvCoord: mapViewModel.currentRegion.center) < calculateDistance(itemCoord: $1.locationCoordinate, mvCoord: mapViewModel.currentRegion.center) })) { storeItem in
                                StoreItemView(mapViewModel: mapViewModel, profileViewModel: profileViewModel, storeItem: storeItem)
                                    .padding(.bottom, 10)
                            }
                        }
                        
                        // 별점 순 정렬
                        else if sortMode == .rating {
                            ForEach(filteredStoreItems.sorted(by: { $0.rating > $1.rating })) { storeItem in
                                StoreItemView(mapViewModel: mapViewModel, profileViewModel: profileViewModel, storeItem: storeItem)
                            }
                        }
                        
                        // 가격 낮은 순
                        else if sortMode == .priceIncrease {
                            ForEach(filteredStoreItems.sorted(by: { $0.pricing.cut < $1.pricing.cut })) { storeItem in
                                StoreItemView(mapViewModel: mapViewModel, profileViewModel: profileViewModel, storeItem: storeItem)
                            }
                        }
                        
                        // 가격 높은 순
                        else if sortMode == .priceDecrease {
                            ForEach(filteredStoreItems.sorted(by: { $0.pricing.cut > $1.pricing.cut })) { storeItem in
                                StoreItemView(mapViewModel: mapViewModel, profileViewModel: profileViewModel, storeItem: storeItem)
                            }
                        }
                    }
                })
                .navigationTitle("강남구 애견미용실")
                .navigationBarHidden(true)
                .padding(.top, 10)
            }
            .padding(10)
        })
        .cornerRadius(30)
        
        // frame 높이 설정
        .frame(height: viewHeight)
        
        // 드래그 Gesture
        .gesture(
            DragGesture()
                .onChanged { value in
                    if screenMode != .hidden {
                        // Half
                        if screenMode == .half {
                            if viewHeight > UIScreen.main.bounds.height * ScreenMode.half.rawValue - 30 {
                                viewHeight -= value.translation.height
                            }
                        }
                        
                        // fullscreen
                        else {
                            if value.translation.height >= 0 {
                                if viewHeight > UIScreen.main.bounds.height * ScreenMode.half.rawValue - 30 {
                                    viewHeight -= value.translation.height
                                }
                            }
                        }
                    }
                }
                .onEnded { value in
                    if screenMode != .hidden {
                        withAnimation(.spring()) {
                            let minHeight: CGFloat = UIScreen.main.bounds.height * ScreenMode.half.rawValue
                            let maxHeight: CGFloat = UIScreen.main.bounds.height * ScreenMode.fullScreen.rawValue
                            let boundHeight: CGFloat = (minHeight + maxHeight) / 2

                            // 기준 아래로 내려가면 half 모드로 변경
                            if viewHeight < boundHeight {
                                viewHeight = minHeight
                                screenMode = .half
                            }
                            
                            // 최대 높이를 초과하면 최대 높이로 설정
                            else if viewHeight > boundHeight {
                                viewHeight = maxHeight
                                screenMode = .fullScreen
                            }
                        }
                    }
                }
        )
    }
    
    private func searchModel(textArray: [String], keyword: String) -> Bool {
        let origin: String = textArray.joined(separator: " ").lowercased()
        let keyword: String = keyword.lowercased()
        
        return origin.contains(keyword)
    }
    
    private func checkIsSaved(isSaved: Bool?) -> Bool {
        if !isSavedStoreShowing {
            return true
        } else {
            if let isSaved = isSaved {
                return isSaved
            } else {
                return false
            }
        }
    }
    
    private func hideView() {
        if screenMode == .hidden {
            viewHeight = UIScreen.main.bounds.height * ScreenMode.half.rawValue
            screenMode = .half
        } else {
            viewHeight = UIScreen.main.bounds.height * ScreenMode.hidden.rawValue
            screenMode = .hidden
        }
    }
}

#Preview {
    @ObservedObject var mapViewModel = MapViewModel()
    @ObservedObject var storeViewModel = StoreViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    return Group {
        ZStack(alignment: .bottom) {
            VStack {
                Spacer()
                Text("")
                Spacer()
            }
            
            StoreListView(mapViewModel: mapViewModel, storeViewModel: storeViewModel, profileViewModel: profileViewModel)
        }
        .ignoresSafeArea()
        .background(.green)
    }
}
