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
    
    // 권한 설정
    @State private var isPermissionAlertPresented: Bool = false
    
    // 개발자 메일 보내기
    @State private var isErrorDeclarationModalPresented: Bool = false
    @State private var isCopyFinishPresented: Bool = false
    
    // 개인정보 처리방침
    @State private var isPrivacyViewPresented: Bool = false
    
    // 프로필 초기화 경고
    @State private var isResetProfileAlertPresented: Bool = false
    
    // 앱 초기화 경고
    @State private var isResetAlertPresented: Bool = false
    
    // 프로필 View Model
    @ObservedObject var profileViewModel: ProfileViewModel
    
    // App Version
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
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(Color("Background1"))
                            .stroke(Color("Stroke1"), lineWidth: 1)
                        
                        HStack {
                            Spacer()
                                .frame(width: 15)
                            
                            Image(systemName: "bell.badge")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .foregroundStyle(Color("Foreground1"))
                            
                            Spacer()
                                .frame(width: 10)
                            
                            Text("알림 받기")
                                .foregroundStyle(Color("Foreground1"))
                            
                            Spacer()
                            
                            Toggle(isOn: $testIsOn1) {
                                
                            }
                            .disabled(true)
                            
                            Spacer()
                                .frame(width: 10)
                        }
                    }
                    .frame(height: 48)
                    
                    Spacer()
                        .frame(height: 10)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(Color("Background1"))
                            .stroke(Color("Stroke1"), lineWidth: 1)
                        
                        HStack {
                            Spacer()
                                .frame(width: 15)
                            
                            Image(systemName: "bell.badge.waveform")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .foregroundStyle(Color("Foreground1"))
                            
                            Spacer()
                                .frame(width: 10)
                            
                            Text("마케팅 알림 받기")
                                .foregroundStyle(Color("Foreground1"))
                            
                            Spacer()
                            
                            Toggle(isOn: $testIsOn2) {
                                
                            }
                            .disabled(true)
                            
                            Spacer()
                                .frame(width: 10)
                        }
                    }
                    .frame(height: 48)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Text("권한 수정")
                        .font(.headline)
                        .bold()
                    
                    Spacer()
                        .frame(height: 10)
                    
                    Button {
                        isPermissionAlertPresented = true
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
                        isPrivacyViewPresented = true
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
                        isErrorDeclarationModalPresented = true
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
                        .foregroundColor(.red)
                    
                    Spacer()
                        .frame(height: 10)
                    
                    // 프로필 초기화
                    if !profileViewModel.dogProfile.isEmpty {
                        Button {
                            isResetProfileAlertPresented = true
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
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(Color("Background1"))
                                .stroke(Color("Stroke1"), lineWidth: 1)
                            
                            HStack {
                                Spacer()
                                    .frame(width: 15)
                                
                                Image(systemName: "exclamationmark.triangle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .foregroundStyle(.gray)
                                
                                Spacer()
                                    .frame(width: 10)
                                
                                Text("프로필 데이터가 없어요")
                                    .foregroundStyle(.gray)
                                
                                Spacer()
                            }
                        }
                        .frame(height: 48)
                    }
                    
                    Spacer()
                        .frame(height: 10)
                    
                    // 앱 초기화
                    Button {
                        isResetAlertPresented = true
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
                        Text("PETSPACE ver \(appVersion)\nAll Right Reserved.")
                            .foregroundStyle(.gray)
                            .font(.system(size: 11))
                        Spacer()
                    }
                    .padding(.bottom, 10)
                }
            }
        }
        .padding()
        
        // 개인정보 처리방침 뷰
        .sheet(isPresented: $isPrivacyViewPresented, onDismiss: {
            GATracking.sendLogEvent(eventName: GATracking.InfoViewMessage.INFO_PAGE_PRIVACY_CLOSE, params: nil)
        }, content: {
            SimpleTextView(title: "개인정보 처리방침", text: TextCollections.privacyText.rawValue)
                .padding()
                .padding(.top, 30)
                .onAppear() {
                    // View 방문 이벤트
                    GATracking.eventScreenView(screenName: GATracking.ScreenNames.privacyView)
                }
                .onDisappear() {
                    // View 방문 이벤트
                    GATracking.eventScreenView(screenName: GATracking.ScreenNames.infoView)
                }
        })
        
        // 권한 허가 수정 안내 모달
        .alert("권한 허가 수정 안내", isPresented: $isPermissionAlertPresented, actions: {
            Button("설정 앱으로 이동할래요", role: .cancel) {
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
                GATracking.sendLogEvent(eventName: GATracking.InfoViewMessage.INFO_PAGE_EDIT_PRIVACY_BUTTON_TO_SETTING, params: nil)
            }
            Button("알겠어요", role: nil) {
                GATracking.sendLogEvent(eventName: GATracking.InfoViewMessage.INFO_PAGE_EDIT_PRIVACY_BUTTON_PASS, params: nil)
            }
        }, message: {
            Text("권한 허가 수정은 Apple 정책 상 직접 iPhone 설정 앱 - 펫스페이스 에서 권한을 수정할 수 있어요.")
        })
        
        // 기능 오류 신고 모달
        .alert("피드백 안내", isPresented: $isErrorDeclarationModalPresented, actions: {
            Button("메일을 작성할래요", role: nil) {
                // 메일 보내기
                let emailAddr = "mailto:hoeunlee228@gmail.com"
                print(emailAddr)
                guard let emailUrl = URL(string: emailAddr) else { return }
                UIApplication.shared.open(emailUrl)
                GATracking.sendLogEvent(eventName: GATracking.InfoViewMessage.INFO_PAGE_ERROR_DECLARATION_WRITE_MAIL, params: nil)
            }
            Button("메일 주소를 복사할래요", role: nil) {
                // 클립보드에 복사
                UIPasteboard.general.string = "hoeunlee228@gmail.com"
                isCopyFinishPresented = true
                GATracking.sendLogEvent(eventName: GATracking.InfoViewMessage.INFO_PAGE_ERROR_DECLARATION_COPY, params: nil)
            }
            Button("알겠어요", role: nil) {
                //
            }
        }, message: {
            Text("피드백은 hoeunlee228@gmail.com으로 메일을 작성해주세요. 항상 소중한 의견에 귀를 기울이며 감사하는 펫스페이스가 되겠습니다.")
        })
        
        // 복사 완료 모달
        .alert("복사 완료", isPresented: $isCopyFinishPresented, actions: {
            Button("알겠어요", role: nil) {
                GATracking.sendLogEvent(eventName: GATracking.InfoViewMessage.INFO_PAGE_ERROR_DECLARATION_PASS, params: nil)
            }
        }, message: {
            Text("클립보드에 복사가 완료되었어요. 소중한 의견을 작성해 보내주세요.")
        })
        
        // 프로필 데이터 초기화
        .alert("프로필 데이터를 초기화할까요?", isPresented: $isResetProfileAlertPresented, actions: {
            Button("초기화할게요", role: .destructive) {
                
            }
            Button("취소할게요", role: .cancel) {
                
            }
        }, message: {
            Text("앱 저장소에 저장된 모든 프로필 데이터를 제거합니다. 삭제된 데이터는 복구할 수 없습니다.")
        })
        
        // 앱 데이터 초기화
        .alert("앱을 초기화할까요?", isPresented: $isResetAlertPresented, actions: {
            Button("초기화할게요", role: .destructive) {
                
            }
            Button("취소할게요", role: .cancel) {
                
            }
        }, message: {
            Text("앱 저장소에 저장된 모든 데이터를 제거하여 앱을 초기 상태로 되돌립니다. 삭제된 데이터는 복구할 수 없습니다.")
        })
    }
    
    // 프로필 데이터 제거
    func resetProfileData() {
        // 프로필 뷰 모델에 모든 데이터 제거
        profileViewModel.resetAllProfile()
    }
    
    // 앱 데이터 제거
    func resetApp() {
        // 프로필 데이터 제거
        resetProfileData()
        
        // 앱 초기 상태로 되돌림 (WelcomeView 표시)
        UserDefaults.standard.set(false, forKey: "hasShownWelcomeView")
    }
}

#Preview {
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    return Group {
        SettingView(profileViewModel: profileViewModel)
    }
}
