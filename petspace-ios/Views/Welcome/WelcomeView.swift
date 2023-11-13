//
//  WelcomeView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI
import ConfettiSwiftUI

struct WelcomeView: View {
    
    // Environment
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    
    // MapViewModel
    @ObservedObject var mapViewModel: MapViewModel
    
    // ProfileViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    // 첫 접속인지 여부
    var isWelcome: Bool
    
    // ConfettiCannon Library
    @State private var counter: Int = 0
    
    // 등록이 시작되었는지
    @State private var isRegisterStarted: Bool = false
    
    // 프로필 뷰 Present
    @State private var isProfileViewPresented: Bool = false
    
    // 권한 뷰
    @State private var isPermissionViewPresented: Bool = false
    
    // 베타 Info 뷰
    @State private var isBetaInfoViewPresented: Bool = false
    
    // 개인정보 처리방침 뷰
    @State private var isPrivacyViewPresented: Bool = false
    
    // 오류 신고 뷰
    @State private var isErrorDeclarationViewPresented: Bool = false
    
    // Alert 모달
    @State private var isAlert1Presented: Bool = false
    @State private var isAlert2Presented: Bool = false
    
    // 권한 관련 안내 모달
    @State private var isPermissionAlertPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .center, content: {
                    
            ZStack {
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
                ZStack {
                    Text("펫스페이스에 오신 것을 \n환영합니다!")
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    ConfettiCannon(counter: $counter, num: 20, repetitions: 3, repetitionInterval: 0.3)
                        .onAppear() {
                            counter += 1
                        }
                }
                    
            } else {
                Text("펫스페이스")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text("베타")
                    .italic()
                    .foregroundStyle(.secondary)
            }
            
            // 안내
            ScrollView {
                VStack(alignment: .center, spacing: 10,content: {
                    WelcomeRow(iconName: "map.circle", mainColor: .blue, title: "우리 동네 애견미용실 한 눈에 비교", subtitle: "소중한 우리 아이를 위한 미용, 어디가 좋을지 한 눈에 비교해보세요. (강남구 지역)")
                    WelcomeRow(iconName: "dog.circle", mainColor: .blue, title: "프로필 등록으로 아이들 관리를 한 번에", subtitle: "프로필에 등록한 우리 아이들 정보를 기반으로 수백 건의 맞춤형 가격 비교를 할 수 있어요.")
                    WelcomeRow(iconName: "calendar.circle", mainColor: .blue, title: "귀찮은 전화, 문의 없이 터치로 예약 끝!", subtitle: "예약 가능한 시간 조회부터 예약, 변경, 취소까지 한 곳에서 터치로 쉽고 편하게! (지원 예정)")
                })
                .padding()
            }
            
            Spacer()
            
            // 첫 접속인 경우
            if isWelcome {
                VStack(spacing: 10, content: {
                    // 안내 문구
                    Text("프로필을 등록하면 맞춤형 가격 추천을 받을 수 있어요")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    
                    // 프로필 등록 버튼
                    Button {
                        isProfileViewPresented = true
                        isRegisterStarted = true
                        ServerLogger.sendLog(group: "TEST_LOG", message: "WELCOME_PAGE_PROFILE_ADD_BUTTON")
                    } label: {
                        Text("프로필 등록하기")
                            .standardButtonText()
                    }
                    .standardButton()
                    .disabled(isRegisterStarted)
                    
                    // 나중에 등록 버튼
                    Button {
                        isAlert1Presented = true
                        ServerLogger.sendLog(group: "TEST_LOG", message: "WELCOME_PAGE_PROFILE_PASS_BUTTON")
                    } label: {
                        Text("나중에 등록할래요")
                            .standardButtonText()
                    }
                    .standardButton(backgroundColor: .gray)
                    .disabled(isRegisterStarted)
                    
                    // Profile View
                    .fullScreenCover(isPresented: $isProfileViewPresented, onDismiss: {
                        isPermissionViewPresented = true
                    }, content: {
                        ProfileView(isPresented: $isProfileViewPresented, isEditing: true, isFirstRegister: true, profileViewModel: profileViewModel, mapViewModel: mapViewModel)
                            .padding()
                    })
                    
                    // 프로필 등록없이 시작 경고 모달
                    .alert("프로필 등록없이 시작할까요?", isPresented: $isAlert1Presented, actions: {
                        Button("프로필 등록하기", role: nil) {
                            isProfileViewPresented = true
                            isRegisterStarted = true
                            ServerLogger.sendLog(group: "TEST_LOG", message: "WELCOME_PAGE_PROFILE_PASS_BUTTON_ADD")
                        }
                        Button("나중에 등록할래요", role: nil) {
                            isAlert2Presented = true
                            isRegisterStarted = true
                            ServerLogger.sendLog(group: "TEST_LOG", message: "WELCOME_PAGE_PROFILE_PASS_BUTTON_PASS")
                        }
                    }, message: {
                        Text("프로필을 등록하면 우리 아이의 맞춤형 미용 가격을 바로 확인할 수 있어요.")
                    })
                    
                    // 프로필 등록 안내 모달
                    .alert("프로필 등록", isPresented: $isAlert2Presented, actions: {
                        Button("알겠어요") {
                            // STEP 3 Present Permission View
                            isPermissionViewPresented = true
                        }
                    }, message: {
                        Text("프로필 등록은 언제든지 앱 내 프로필 페이지에서 가능해요")
                    })
                    
                    // Permission View
                    .fullScreenCover(isPresented: $isPermissionViewPresented, onDismiss: {
                        isBetaInfoViewPresented = true
                    }, content: {
                        PermissionView(isPresented: $isPermissionViewPresented, mapViewModel: mapViewModel)
                            .padding()
                    })
                    
                    // Beta Info View
                    .fullScreenCover(isPresented: $isBetaInfoViewPresented, onDismiss: {
                        // isPresented = false
                        dismiss()
                        
                        UserDefaults.standard.set(true, forKey: "hasShownWelcomeView")
                        ServerLogger.sendLog(group: "TEST_LOG", message: "WELCOME_FINISH")
                        
                    }, content: {
                        BetaInfoView(isPresented: $isBetaInfoViewPresented)
                            .padding()
                    })
                })
                .padding()
            } 
            
            // 첫 접속이 아닐 경우 isWelcome == false
            else {
                VStack {
                    // 개인정보 처리방침 뷰
                    Button {
                        isPrivacyViewPresented = true
                    } label: {
                        Text("개인정보처리방침")
                            .foregroundStyle(.primary)
                    }
                    .padding(.bottom, 10)
                    
                    // 권한 허가 수정 버튼 -> 설정으로 연결
                    Button {
                        //
                        isPermissionAlertPresented = true
                    } label: {
                        Text("권한 허가 수정")
                            .standardButtonText(foregroundColor: Color("Background1"))
                    }
                    .standardButton(backgroundColor: Color("Foreground1"))
                    
                    // 기능 오류 신고 버튼
                    Button {
                        isErrorDeclarationViewPresented = true
                    } label: {
                        Text("기능 오류 신고하기")
                            .standardButtonText()
                    }
                    .standardButton()
                }
                .padding()
                
                // 개인정보 처리방침 뷰
                .sheet(isPresented: $isPrivacyViewPresented, content: {
                    SimpleTextView(title: "개인정보 처리방침", text: TextCollections.privacyText.rawValue)
                        .padding()
                        .padding(.top, 30)
                })
                
                // 권한 허가 수정 안내 모달
                .alert("권한 허가 수정 안내", isPresented: $isPermissionAlertPresented, actions: {
                    Button("설정 앱으로 이동할래요", role: .cancel) {
                        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                        
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }
                    Button("알겠어요", role: nil) {
                        
                    }
                }, message: {
                    Text("권한 허가 수정은 Apple 정책 상 직접 iPhone 설정 앱 - 펫스페이스 에서 권한을 수정할 수 있어요.")
                })
                
                // 오류 신고 뷰
                .sheet(isPresented: $isErrorDeclarationViewPresented, onDismiss: {
                    
                }, content: {
                    ErrorDeclarationView(isPresent: $isErrorDeclarationViewPresented)
                        .padding()
                        .padding(.top, 20)
                })
            }
        })
    }
}

#Preview {
    @ObservedObject var mapViewModel = MapViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    return Group {
        WelcomeView(isPresented: .constant(true), mapViewModel: mapViewModel, profileViewModel: profileViewModel, isWelcome: true)
    }
    
}

#Preview {
    @ObservedObject var mapViewModel = MapViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    return Group {
        WelcomeView(isPresented: .constant(true), mapViewModel: mapViewModel, profileViewModel: profileViewModel, isWelcome: false)
    }
}
