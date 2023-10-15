//
//  ButtonBarView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 10/15/23.
//

import SwiftUI

struct ButtonBarView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                ButtonBar()
                    .padding(.trailing, 20)
            }
            Spacer()
        }
    }
}

#Preview {
    ButtonBarView()
}

struct ButtonBar: View {
    
    @State private var isExpaned: Bool = false
    @StateObject private var mapViewModel = MapViewModel()
    
    var body: some View {
        
        VStack(spacing: 0, content: {
            
            Button {
                withAnimation(.spring()) {
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
                    // map tracking mode
                    mapViewModel.checkIfLocationServicesIsEnabled()
                } label: {
                    Image(systemName: mapViewModel.isLocationServiceEnabled ? "location" : "location.slash")
                        .frame(width: 48, height: 48)
                }
                
                // 필터링
//                Menu {
//                    Button("거리") {
//                        
//                    }
//                    Button("가격") {
//                        
//                    }
//                    Button("별점") {
//                        
//                    }
//                } label: {
//                    Image(systemName: "line.3.horizontal.decrease.circle")
//                        .frame(width: 48, height: 48)
//                }
                
                // 프로필 수정으로 이동
                Button {
                    // to profile
                } label: {
                    Image(systemName: "dog.circle")
                        .frame(width: 48, height: 48)
                }
                
                // 앱 정보
                Button {
                    // information
                } label: {
                    Image(systemName: "info.circle")
                        .frame(width: 48, height: 48)
                }
            }
        })
        .font(.system(size: 24))
        .materialBackground()
    }
}

#Preview {
    ButtonBar()
}
