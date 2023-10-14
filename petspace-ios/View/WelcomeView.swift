//
//  WelcomeView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 10/15/23.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(alignment: .center, content: {
            Spacer()
            
            Image("AppLogo")
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(30)
                .padding(.bottom, 10)
            
            Text("펫스페이스에 오신 것을 \n환영합니다!")
                .font(.title)
                .multilineTextAlignment(.center)
            
            
            VStack(alignment: .center, spacing: 10,content: {
                WelcomeRow(iconName: "map.circle", mainColor: .blue, title: "우리 동네 애견미용실 한 눈에 비교", subtitle: "소중한 우리 아이를 위한 미용, 어디가 좋을지 한 눈에 비교해보세요. (강남구 지역)")
                WelcomeRow(iconName: "dog.circle", mainColor: .blue, title: "프로필 등록으로 아이들 관리를 한 번에", subtitle: "프로필에 등록한 우리 아이들 정보를 기반으로 수백 건의 맞춤형 가격 비교를 할 수 있어요.")
                WelcomeRow(iconName: "calendar.circle", mainColor: .blue, title: "귀찮은 전화, 문의 없이 터치로 예약 끝!", subtitle: "예약 가능한 시간 조회부터 예약, 변경, 취소까지 한 곳에서 터치로 쉽고 편하게! (지원 예정)")
            })
            .padding()
            
            Spacer()
            
            Button("확인") {
                //
            }
            .bigButton()
            .padding()
        })
    }
}

#Preview {
    Text("")
        .sheet(isPresented: .constant(true), content: {
            WelcomeView()
        })
}

struct WelcomeRow: View {
    
    var iconName: String
    var mainColor: Color
    var title: String
    var subtitle: String
    
    var body: some View {
        GroupBox {
            HStack {
                Image(systemName: iconName)
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(mainColor)
                    .padding(.trailing, 8)
                
                VStack(alignment: .leading, content: {
                    Text(title)
                        .font(.system(size: 15))
                        .multilineTextAlignment(.leading)
                        .bold()
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .multilineTextAlignment(.leading)
                        
                })
                Spacer()
            }
        }
    }
}

#Preview {
    Group {
        WelcomeRow(iconName: "map.circle", mainColor: .blue, title: "우리 동네 애견미용실 한 눈에 비교", subtitle: "소중한 우리 아이를 위한 미용, 어디가 좋을지 한 눈에 비교해보세요. (강남구 지역)")
        WelcomeRow(iconName: "dog.circle", mainColor: .blue, title: "프로필 등록으로 아이들 관리를 한 번에", subtitle: "프로필에 등록한 우리 아이들 정보를 기반으로 수백 건의 맞춤형 가격 비교를 할 수 있어요.")
        WelcomeRow(iconName: "calendar.circle", mainColor: .blue, title: "귀찮은 전화, 문의 없이 터치로 예약 끝!", subtitle: "예약 가능한 시간 조회부터 예약, 변경, 취소까지 한 곳에서 터치로 쉽고 편하게! (지원 예정)")
    }
    .padding()
}

