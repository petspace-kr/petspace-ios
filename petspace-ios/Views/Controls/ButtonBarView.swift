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
    
    // Profile View Model
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                ButtonBar(mapViewModel: mapViewModel, profileViewModel: profileViewModel, isSavedStoreShowing: $isSavedStoreShowing)
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
    
    // Profile View Model
    @ObservedObject var profileViewModel: ProfileViewModel
    
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
                /* Button {
                    // 현재 위치로
                    // 기본 위치로
                } label: {
                    Image(systemName: (mapViewModel.userLatitude == 0 || mapViewModel.userLongitude == 0) ? "location.slash" : "location")
                        .frame(width: 48, height: 48)
                }
                .disabled(mapViewModel.userLatitude == 0 || mapViewModel.userLongitude == 0)*/
                
                // 프로필 수정으로 이동
                Button {
                    // to profile
                    isProfileViewPresented = true
                    GATracking.sendLogEvent(eventName: GATracking.EtcViewMessage.BAR_PROFILE_PAGE_OPEN, params: nil)
                } label: {
                    Image(systemName: "dog.circle")
                        .frame(width: 48, height: 48)
                }
                
                // 저장된 매장 버튼
                /* Button {
                    if isSavedStoreShowing {
                        GATracking.sendLogEvent(eventName: GATracking.EtcViewMessage.BAR_SAVED_SHOWING_OFF, params: nil)
                        isSavedStoreShowing = false
                    }
                    else {
                        GATracking.sendLogEvent(eventName: GATracking.EtcViewMessage.BAR_SAVED_SHOWING_ON, params: nil)
                        isSavedStoreShowing = true
                    }
                } label: {
                    Image(systemName: isSavedStoreShowing ? "heart.fill" : "heart")
                        .frame(width: 48, height: 48)
                }*/
                
                // 설정
                /* Button {
                    isSettingViewPresented = true
                    GATracking.sendLogEvent(eventName: GATracking.EtcViewMessage.BAR_SETTING_PAGE_OPEN, params: nil)
                } label: {
                    Image(systemName: "gearshape.circle")
                        .frame(width: 48, height: 48)
                } */
                
                // 예약 페이지로 이동
                Button {
                    isHistoryViewPresented = true
                    GATracking.sendLogEvent(eventName: GATracking.EtcViewMessage.BAR_BOOKING_PAGE_OPEN, params: nil)
                } label: {
                    Image(systemName: "book.circle")
                        .frame(width: 48, height: 48)
                }
        
                // 앱 정보
                Button {
                    // information
                    isInfoViewPresented = true
                    GATracking.sendLogEvent(eventName: GATracking.EtcViewMessage.BAR_INFO_PAGE_OPEN, params: nil)
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
            GATracking.sendLogEvent(eventName: GATracking.EtcViewMessage.BAR_PROFILE_PAGE_CLOSE, params: nil)
        }, content: {
            ProfileView(isPresented: $isProfileViewPresented, isEditing: false, isFirstRegister: false, profileViewModel: profileViewModel, mapViewModel: mapViewModel)
                .padding()
                .padding(.top, 20)
                .presentationDragIndicator(.visible)
                .onAppear() {
                    // View 방문 이벤트
                    GATracking.eventScreenView(screenName: GATracking.ScreenNames.profileView)
                }
                .onDisappear() {
                    // View 방문 이벤트
                    GATracking.eventScreenView(screenName: GATracking.ScreenNames.mainView)
                }
        })
        
        // 설정 뷰 보이기
        .sheet(isPresented: $isSettingViewPresented, onDismiss: {
            GATracking.sendLogEvent(eventName: GATracking.EtcViewMessage.BAR_SETTING_PAGE_CLOSE, params: nil)
        }, content: {
            SettingView()
                .padding()
                .padding(.top, 20)
                .presentationDragIndicator(.visible)
                .onAppear() {
                    // View 방문 이벤트
                    GATracking.eventScreenView(screenName: GATracking.ScreenNames.settingView)
                }
                .onDisappear() {
                    // View 방문 이벤트
                    GATracking.eventScreenView(screenName: GATracking.ScreenNames.mainView)
                }
        })
        
        // Info 뷰 보이기
        .sheet(isPresented: $isInfoViewPresented, onDismiss: {
            GATracking.sendLogEvent(eventName: GATracking.EtcViewMessage.BAR_INFO_PAGE_CLOSE, params: nil)
        }, content: {
            WelcomeView(isPresented: $isInfoViewPresented, mapViewModel: mapViewModel, profileViewModel: profileViewModel, isWelcome: false)
                .onAppear() {
                    // View 방문 이벤트
                    GATracking.eventScreenView(screenName: GATracking.ScreenNames.infoView)
                }
        })
        
        // History 뷰 보이기
        .sheet(isPresented: $isHistoryViewPresented, content: {
            HistoryView()
                .padding()
                .padding(.top, 20)
                .presentationDragIndicator(.visible)
                .onAppear() {
                    // View 방문 이벤트
                    GATracking.eventScreenView(screenName: GATracking.ScreenNames.historyView)
                }
                .onDisappear() {
                    // View 방문 이벤트
                    GATracking.eventScreenView(screenName: GATracking.ScreenNames.mainView)
                }
        })
    }
}

#Preview {
    @ObservedObject var mapViewModel = MapViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    @State var isSavedStoreShowing: Bool = false
    
    return Group {
        ButtonBarView(isSavedStoreShowing: $isSavedStoreShowing, mapViewModel: mapViewModel, profileViewModel: profileViewModel)
    }
}
