//
//  SettingView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct SettingView: View {
    
    @State private var testIsOn1: Bool = false
    @State private var testIsOn2: Bool = false
    
    var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        } else {
            return "N/A"
        }
    }
    
    var body: some View {
        NavigationStack {
            HStack {
                Text("설정")
                    .font(.title)
                    .bold()
                
                Spacer()
            }
            
            Spacer()
                .frame(height: 30)
            
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Text("필수 알림 설정")
                        .font(.headline)
                        .bold()
                    
                    Spacer()
                        .frame(height: 10)
                    
                    Button {
                        
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(Color("Background1"))
                                .stroke(Color("Stroke1"), lineWidth: 1)
                            
                            HStack {
                                Spacer()
                                    .frame(width: 15)
                                
                                Image(systemName: "bell")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(Color("Foreground1"))
                                
                                Spacer()
                                    .frame(width: 10)
                                
                                Text("알림")
                                    .foregroundStyle(Color("Foreground1"))
                                
                                Spacer()
                                
                                Toggle(isOn: $testIsOn1) {
                                    
                                }
                                
                                Spacer()
                                    .frame(width: 10)
                            }
                        }
                        .frame(height: 48)
                    }
                    
                    Spacer()
                        .frame(height: 10)
                    
                    Button {
                        
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(Color("Background1"))
                                .stroke(Color("Stroke1"), lineWidth: 1)
                            
                            HStack {
                                Spacer()
                                    .frame(width: 15)
                                
                                Image(systemName: "bell")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(Color("Foreground1"))
                                
                                Spacer()
                                    .frame(width: 10)
                                
                                Text("마케팅 알림")
                                    .foregroundStyle(Color("Foreground1"))
                                
                                Spacer()
                                
                                Toggle(isOn: $testIsOn2) {
                                    
                                }
                                
                                Spacer()
                                    .frame(width: 10)
                            }
                        }
                        .frame(height: 48)
                    }
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Text("권한 수정")
                        .font(.headline)
                        .bold()
                    
                    Spacer()
                        .frame(height: 10)
                    
                    Button {
                        
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(Color("Background1"))
                                .stroke(Color("Stroke1"), lineWidth: 1)
                            
                            HStack {
                                Spacer()
                                    .frame(width: 15)
                                
                                Image(systemName: "hand.raised.square")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(Color("Foreground1"))
                                
                                Spacer()
                                    .frame(width: 10)
                                
                                Text("앱 권한 허가 및 수정")
                                    .foregroundStyle(Color("Foreground1"))
                                
                                Spacer()
                            }
                        }
                        .frame(height: 48)
                    }
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Text("개인정보 처리방침")
                        .font(.headline)
                        .bold()
                    
                    Spacer()
                        .frame(height: 10)
                    
                    Button {
                        
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(Color("Background1"))
                                .stroke(Color("Stroke1"), lineWidth: 1)
                            
                            HStack {
                                Spacer()
                                    .frame(width: 15)
                                
                                Image(systemName: "shield.lefthalf.filled")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(Color("Foreground1"))
                                
                                Spacer()
                                    .frame(width: 10)
                                
                                Text("개인정보 처리방침")
                                    .foregroundStyle(Color("Foreground1"))
                                
                                Spacer()
                            }
                        }
                        .frame(height: 48)
                    }
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Text("피드백")
                        .font(.headline)
                        .bold()
                    
                    Spacer()
                        .frame(height: 10)
                    
                    Button {
                        
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(Color("Background1"))
                                .stroke(Color("Stroke1"), lineWidth: 1)
                            
                            HStack {
                                Spacer()
                                    .frame(width: 15)
                                
                                Image(systemName: "envelope")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(Color("Foreground1"))
                                
                                Spacer()
                                    .frame(width: 10)
                                
                                Text("개발자에게 메일 보내기")
                                    .foregroundStyle(Color("Foreground1"))
                                
                                Spacer()
                            }
                        }
                        .frame(height: 48)
                    }
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Text("초기화")
                        .font(.headline)
                        .bold()
                    
                    Spacer()
                        .frame(height: 10)
                    
                    Button {
                        
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(Color("Background1"))
                                .stroke(Color("Stroke1"), lineWidth: 1)
                            
                            HStack {
                                Spacer()
                                    .frame(width: 15)
                                
                                Image(systemName: "xmark.bin")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(.red)
                                
                                Spacer()
                                    .frame(width: 10)
                                
                                Text("프로필 초기화")
                                    .foregroundStyle(.red)
                                
                                Spacer()
                            }
                        }
                        .frame(height: 48)
                    }
                    
                    Spacer()
                        .frame(height: 10)
                    
                    Button {
                        
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(Color("Background1"))
                                .stroke(Color("Stroke1"), lineWidth: 1)
                            
                            HStack {
                                Spacer()
                                    .frame(width: 15)
                                
                                Image(systemName: "xmark.octagon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(.red)
                                
                                Spacer()
                                    .frame(width: 10)
                                
                                Text("앱 초기화")
                                    .foregroundStyle(.red)
                                
                                Spacer()
                            }
                        }
                        .frame(height: 48)
                    }
                    
                    Spacer()
                        .frame(height: 30)
                    
                    HStack {
                        Spacer()
                        Text("PETSPACE ver \(appVersion)")
                            .foregroundStyle(.gray)
                            .font(.system(size: 11))
                        Spacer()
                    }
                    .padding(.bottom, 10)
                }
            }
        }
        .padding()
    }
}

#Preview {
    SettingView()
}
