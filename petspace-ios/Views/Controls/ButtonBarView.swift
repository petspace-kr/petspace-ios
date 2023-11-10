//
//  ButtonBarView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct ButtonBarView: View {
    
    @Binding var isSavedStoreShowing: Bool
    
    // MapViewModel
    @ObservedObject var mapViewModel: MapViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                ButtonBar(mapViewModel: mapViewModel, isSavedStoreShowing: $isSavedStoreShowing)
                    .padding(.trailing, 16)
            }
            Spacer()
        }
    }
}

struct ButtonBar: View {
    
    @State private var isExpaned: Bool = false
    
    // MapViewModel
    @ObservedObject var mapViewModel: MapViewModel
    
    // 뷰 Presented
    @State private var isProfileViewPresented: Bool = false
    @State private var isInfoViewPresented: Bool = false
    @State private var isHistoryViewPresented: Bool = false
    @State private var isSettingViewPresented: Bool = false
    
    @Binding var isSavedStoreShowing: Bool
    
    var body: some View {
        VStack(spacing: 0, content: {
            
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpaned.toggle()
                }
            } label: {
                // Image(systemName: isExpaned ? "chevron.up" : "chevron.down")
                Image(systemName: "chevron.down")
                    .frame(width: 48, height: 48)
                    .rotationEffect(.degrees(isExpaned ? 180 : 0))
            }
            
            if isExpaned {
                // 지도 방향 전환 및 내 위치
                Button {
                    
                } label: {
//                    Image(systemName: mapViewModel.isAuthorized == .authorizedWhenInUse ? "location" : "location.slash")
//                        .frame(width: 48, height: 48)
                }
                // .disabled(mapViewModel.isAuthorized != .authorizedWhenInUse)
                
                // 프로필 수정으로 이동
                Button {
                    // to profile
                    isProfileViewPresented = true
                } label: {
                    Image(systemName: "dog.circle")
                        .frame(width: 48, height: 48)
                }
                
                // 저장된 매장 버튼
                Button {
                    isSavedStoreShowing.toggle()
                } label: {
                    Image(systemName: isSavedStoreShowing ? "heart.fill" : "heart")
                        .frame(width: 48, height: 48)
                }
                
                // 설정
                Button {
                    isSettingViewPresented = true
                } label: {
                    Image(systemName: "gearshape.circle")
                        .frame(width: 48, height: 48)
                }
                
                // 예약 페이지로 이동
                Button {
                    isHistoryViewPresented = true
                } label: {
                    Image(systemName: "book.circle")
                        .frame(width: 48, height: 48)
                }
        
                // 앱 정보
                Button {
                    // information
                    isInfoViewPresented = true
                } label: {
                    Image(systemName: "info.circle")
                        .frame(width: 48, height: 48)
                }
                
            }
        })
        .font(.system(size: 24))
        .materialBackground()
        
        // 프로필 뷰 보이기
        .sheet(isPresented: $isProfileViewPresented, onDismiss: {
             
        }, content: {
            ProfileView(isPresented: $isProfileViewPresented)
                .padding()
                .padding(.top, 20)
                .presentationDragIndicator(.visible)
        })
        
        // 설정 뷰 보이기
        .sheet(isPresented: $isSettingViewPresented, onDismiss: {
             
        }, content: {
            SettingView()
                .padding()
                .padding(.top, 20)
                .presentationDragIndicator(.visible)
        })
        
        // Info 뷰 보이기
        .sheet(isPresented: $isInfoViewPresented, onDismiss: {
             
        }, content: {
            WelcomeView(isPresented: $isInfoViewPresented, mapViewModel: mapViewModel, isWelcome: false)
        })
        .sheet(isPresented: $isHistoryViewPresented, content: {
            HistoryView()
                .padding()
                .padding(.top, 20)
                .presentationDragIndicator(.visible)
        })
    }
}

#Preview {
    @ObservedObject var mapViewModel = MapViewModel()
    @State var isSavedStoreShowing: Bool = false
    
    return Group {
        ButtonBarView(isSavedStoreShowing: $isSavedStoreShowing, mapViewModel: mapViewModel)
    }
}
