//
//  StoreListView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 10/14/23.
//

import SwiftUI

struct StoreListView: View {
    @ObservedObject private var mapViewModel = MapViewModel()
    
    @State private var sortMode: Int = 0
    @State private var sortModeString: String = "거리순"
    @State private var viewHeight: CGFloat = UIScreen.main.bounds.height * 0.5
    @State private var isFullScreen: Bool = false
    @State private var startingOffsetY: CGFloat = UIScreen.main.bounds.height * 0.5
    
    @Environment(StoreDatas.self) var storeDatas
    
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
                        .padding(.leading, 6)
                    
                    Spacer()
                    
                    Menu("\(sortModeString)") {
                        Button("거리순") {
                            sortMode = 0
                            sortModeString = "거리순"
                        }
                        Button("별점순") {
                            sortMode = 1
                            sortModeString = "별점순"
                        }
                        Button("가격낮은순") {
                            sortMode = 2
                            sortModeString = "가격낮은순"
                        }
                        Button("가격높은순") {
                            sortMode = 3
                            sortModeString = "가격높은순"
                        }
                    }
                    .padding(.trailing, 6)
                }
                .padding(.top, 4)
                .padding(.bottom, 10)
                
                ScrollView(showsIndicators: false, content: {
                    // 거리순 (가까운 순)
                    if sortMode == 0 {
                        ForEach(storeDatas.items.sorted(by: { $0.distance ?? 0.0 < $1.distance ?? 0.0 })) { storeData in
                            StoreItem(storeData: storeData)
                                .padding(.bottom, 10)
                        }
                    }
                    // 별점순 (높은 순)
                    else if sortMode == 1 {
                        ForEach(storeDatas.items.sorted(by: { $0.rating > $1.rating })) { storeData in
                            StoreItem(storeData: storeData)
                                .padding(.bottom, 10)
                        }
                    }
                    // 가격 낮은 순
                    else if sortMode == 2 {
                        ForEach(storeDatas.items.sorted(by: { $0.pricing.cut < $1.pricing.cut })) { storeData in
                            StoreItem(storeData: storeData)
                                .padding(.bottom, 10)
                        }
                    }
                    // 가격 높은 순
                    else {
                        ForEach(storeDatas.items.sorted(by: { $0.pricing.cut > $1.pricing.cut })) { storeData in
                            StoreItem(storeData: storeData)
                                .padding(.bottom, 10)
                        }
                    }
                })
                .navigationTitle("강남구 애견미용실")
                .navigationBarHidden(true)
            }
            .padding(10)
        })
        .cornerRadius(30)
        .frame(height: viewHeight)
        .gesture(
            DragGesture()
                .onChanged { value in
                    // print(value.translation.height)
                    if isFullScreen == false {
                        if viewHeight > UIScreen.main.bounds.height * 0.5 - 30 {
                            viewHeight -= value.translation.height
                        }
                    }
                    // fullscreen
                    else {
                        if value.translation.height >= 0 {
                            if viewHeight > UIScreen.main.bounds.height * 0.5 - 30 {
                                viewHeight -= value.translation.height
                            }
                        }
                    }
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        let minHeight: CGFloat = UIScreen.main.bounds.height * 0.5
                        let maxHeight: CGFloat = UIScreen.main.bounds.height * 1.0
                        let boundHeight: CGFloat = (minHeight + maxHeight) / 2

                        // 최소 높이 미만으로 내려갔을 때
                        if viewHeight < boundHeight {
                            viewHeight = minHeight
                            isFullScreen = false
                        }
                        // 최대 높이를 초과하면 최대 높이로 설정
                        else if viewHeight > boundHeight {
                            viewHeight = maxHeight
                            isFullScreen = true
                        }
                    }
                }
        )
    }
}

#Preview {
    ZStack {
        StoreListView()
            .environment(StoreDatas())
    }
    .ignoresSafeArea(edges: .bottom)
    .background(Color.green)
}

