//
//  ButtonBarView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct ButtonBarView: View {
    
    @Binding var isRedraw: Bool
    @Binding var isSavedStoreShowing: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                ButtonBar(isRedraw: $isRedraw, isSavedStoreShowing: $isSavedStoreShowing)
                    .padding(.trailing, 16)
            }
            Spacer()
        }
    }
}

struct ButtonBar: View {
    
    @State private var isExpaned: Bool = false
    
    @State private var isProfileViewPresented: Bool = false
    @State private var isInfoViewPresented: Bool = false
    @State private var isHistoryViewPresented: Bool = false
    
    @Binding var isRedraw: Bool
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
//                Button {
//                    isSavedStoreShowing.toggle()
//                } label: {
//                    Image(systemName: isSavedStoreShowing ? "heart.fill" : "heart")
//                        .frame(width: 48, height: 48)
//                }
                
                // 설정
//                Button {
//
//                } label: {
//                    Image(systemName: "gearshape.circle")
//                        .frame(width: 48, height: 48)
//                }
//                .disabled(true)
                
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
        // .materialBackground()
        .sheet(isPresented: $isProfileViewPresented, onDismiss: {
             self.isRedraw.toggle()
        }, content: {
//            ProfileView(isEditing: false, isFirstRegister: false, isPresented: .constant(false), isRedraw: $isRedraw)
//                .padding(.top, 20)
//                .presentationDragIndicator(.visible)
        })
        .sheet(isPresented: $isInfoViewPresented, onDismiss: {
             // self.isRedraw.toggle()
        }, content: {
//            WelcomeView(isPresented: $isInfoViewPresented, isRedraw: $isRedraw, isWelcome: false)
//                .presentationDragIndicator(.visible)
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
    ButtonBarView(isRedraw: .constant(false), isSavedStoreShowing: .constant(false))
}
