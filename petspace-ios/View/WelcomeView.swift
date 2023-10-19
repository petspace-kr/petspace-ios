//
//  WelcomeView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 10/15/23.
//

import SwiftUI
import ConfettiSwiftUI

struct WelcomeView: View {
    
    @Binding var isPresented: Bool
    @State var isProfileViewPresented: Bool = false
    var isWelcome: Bool
    @State var counter:Int = 0
    
    var body: some View {
        VStack(alignment: .center, content: {
            
            ZStack {
                ConfettiCannon(counter: $counter, num: 50, repetitions: 5, repetitionInterval: 1.0)
                    .onAppear() {
                        counter += 1
                    }
                
                Image("AppLogo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(30)
                    .padding(.top, 40)
                    .padding(.bottom, 10)
                    .onTapGesture {
                        counter += 1
                    }
            } 
            
            
            if isWelcome {
                Text("펫스페이스에 오신 것을 \n환영합니다!")
                    .font(.title)
                    .multilineTextAlignment(.center)
            } else {
                Text("펫스페이스")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text("베타")
                    .italic()
                    .foregroundStyle(.secondary)
            }
            
            
            VStack(alignment: .center, spacing: 10,content: {
                WelcomeRow(iconName: "map.circle", mainColor: .blue, title: "우리 동네 애견미용실 한 눈에 비교", subtitle: "소중한 우리 아이를 위한 미용, 어디가 좋을지 한 눈에 비교해보세요. (강남구 지역)")
                WelcomeRow(iconName: "dog.circle", mainColor: .blue, title: "프로필 등록으로 아이들 관리를 한 번에", subtitle: "프로필에 등록한 우리 아이들 정보를 기반으로 수백 건의 맞춤형 가격 비교를 할 수 있어요.")
                WelcomeRow(iconName: "calendar.circle", mainColor: .blue, title: "귀찮은 전화, 문의 없이 터치로 예약 끝!", subtitle: "예약 가능한 시간 조회부터 예약, 변경, 취소까지 한 곳에서 터치로 쉽고 편하게! (지원 예정)")
            })
            .padding()
            
            Spacer()
            
            if isWelcome {
                VStack(spacing: 10, content: {
                    Text("프로필을 등록하면 맞춤형 가격 추천을 받을 수 있어요")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    
                    Button("프로필 등록하기") {
                        isProfileViewPresented = true
                    }
                    .bigButton()
                    Button("프로필 등록없이 시작") {
                        isPresented = false
                    }
                    .bigButton(backgroundColor: Color.secondary)
                    .sheet(isPresented: $isProfileViewPresented, content: {
                        ProfileView(isEditing: true, isFirstRegister: true, isPresented: self.$isProfileViewPresented)
                            .padding(.top, 20)
                    })
                    
                })
                .padding()
            } else {
                VStack {
                    Button {
                        //
                    } label: {
                        Text("개인정보처리방침")
                            .foregroundStyle(.primary)
                    }
                    .padding(.bottom, 10)
                    Button("문의하기") {
                        //
                    }
                    .bigButton()
                }
                .padding()
            }
            
        })
    }
}

#Preview {
    Text("")
        .sheet(isPresented: .constant(true), content: {
            WelcomeView(isPresented: .constant(true), isWelcome: true)
        })
}

#Preview {
    Text("")
        .sheet(isPresented: .constant(true), content: {
            WelcomeView(isPresented: .constant(true), isWelcome: false)
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

