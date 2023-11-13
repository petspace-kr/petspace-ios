//
//  PermissionView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct PermissionView: View {
    
    // Environment
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    
    // View Models
    @ObservedObject var mapViewModel: MapViewModel
    
    // 권한 허용 여부 변수
    @State private var isLocationPermission: Int = 0
    @State private var isPreciseLocationPermission: Int = 0
    @State private var isPhotoPermission: Int = 1
    
    // 위치 권한 허용 타이머 및 관련 변수
    @State private var timer: Timer?
    @State private var isLocationPermissionString: String = "notDetermined"
    
    var body: some View {
        VStack {
            HStack {
                Text("권한 허가가 필요해요")
                    .font(.title)
                    .bold()
                
                Spacer()
            }
            
            Spacer()
                .frame(height: 10)
            
            HStack {
                Text("아래 권한 허가는 필수가 아니에요 \n필요한 권한만 허가해주세요")
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
            Spacer()
                .frame(height: 30)
            
            ScrollView {
                VStack(spacing: 16) {
                    GroupBox {
                        HStack(alignment: .top, spacing: 14) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.blue)
                                    .frame(width: 52, height: 52)
                                    .cornerRadius(10)
                                
                                Image(systemName: "location.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .bold()
                                    .frame(width: 20)
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("위치 데이터 접근 허용")
                                    .bold()
                                    .font(.system(size: 15))
                                    .padding(.bottom, 1)
                                
                                Text("펫스페이스는 사용자의 실제 위치를 기반으로 애견미용실과의 거리를 계산할 때 사용해요. 애견미용실을 거리 순으로 정렬하여 볼 수 있어요.")
                                    .font(.system(size: 12))
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 1)
                                
                                Button {
                                    
                                    mapViewModel.checkLocationServiceEnabled()
                                    
                                    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                                        if isLocationPermission == 0 {
                                            switch mapViewModel.isAuthorized {
                                            case .notDetermined:
                                                isLocationPermission = 0
                                            case .restricted, .denied:
                                                isLocationPermission = 1
                                                ServerLogger.sendLog(group: "TEST_LOG", message: "WELCOME_PERMISSION_LOCATION_DENIED")
                                                print("permission: \(isLocationPermission)")
                                                // timer?.fire()
                                            case .authorizedAlways, .authorizedWhenInUse:
                                                isLocationPermission = 2
                                                ServerLogger.sendLog(group: "TEST_LOG", message: "WELCOME_PERMISSION_PRECISE_LOCATION_ALLOW")
                                                print("permission: \(isLocationPermission)")
                                                // timer?.fire()
                                            @unknown default:
                                                isLocationPermission = 0
                                            }
                                        }
                                        
                                    }
                                    
                                } label: {
                                    Text(isLocationPermission == 0 ? "허가하기" : isLocationPermission == 1 ? "거부됨" : "허가됨")
                                        .bold()
                                        .font(.system(size: 15))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color.accentColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(.infinity)
                                }
                                .disabled(isLocationPermission > 0)
                            }
                            
                            Spacer()
                        }
                    } // End of GroupBox
                    
                    if isLocationPermission > 0 {
                        GroupBox {
                            HStack(alignment: .top, spacing: 14) {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.green)
                                        .frame(width: 52, height: 52)
                                        .cornerRadius(10)
                                    
                                    Image(systemName: "scope")
                                        .resizable()
                                        .scaledToFit()
                                        .bold()
                                        .frame(width: 24)
                                        .foregroundColor(.white)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("더 정확한 위치 허용")
                                        .bold()
                                        .font(.system(size: 15))
                                        .padding(.bottom, 1)
                                    
                                    Text("사용자의 더욱 정확한 위치를 기반으로 애견미용실과의 거리를 더 정확하게 계산할 때 사용해요. 계산된 거리가 다소 부정확하다고 느껴진다면 허가해주세요.")
                                        .font(.system(size: 12))
                                        .multilineTextAlignment(.leading)
                                        .padding(.bottom, 1)
                                    
                                    Button {
                                        mapViewModel.locationManager?.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "테스트")
                                    } label: {
                                        Text(mapViewModel.locationManager?.accuracyAuthorization == .fullAccuracy ? "허가됨" : "거부됨")
                                            .bold()
                                            .font(.system(size: 15))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Color.accentColor)
                                            .foregroundColor(.white)
                                            .cornerRadius(.infinity)
                                    }
                                    .disabled(true)
                                }
                                
                                Spacer()
                            }
                        } // End of GroupBox
                    }
                    
                    GroupBox {
                        HStack(alignment: .top, spacing: 14) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.cyan)
                                    .frame(width: 52, height: 52)
                                    .cornerRadius(10)
                                
                                Image(systemName: "photo.on.rectangle")
                                    .resizable()
                                    .scaledToFit()
                                    .bold()
                                    .frame(width: 24)
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("일부 사진 비공개 접근 허용")
                                    .bold()
                                    .font(.system(size: 15))
                                    .padding(.bottom, 1)
                                
                                Text("프로필 이미지 등록, 애견미용실 후기 작성 시 사진을 추가할 수 있어요. 펫스페이스는 사용자의 사진에 접근하지 않으며, 사용자가 선택한 이미지 데이터만 앱에 저장해요.")
                                    .font(.system(size: 12))
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 1)
                                
                                Button {
                                    
                                } label: {
                                    Text(isPhotoPermission == 0 ? "허가하기" : "허가됨")
                                        .bold()
                                        .font(.system(size: 15))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color.accentColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(.infinity)
                                }
                                .disabled(isPhotoPermission > 0)
                            }
                            
                            Spacer()
                        }
                    } // End of GroupBox
                }
            }
            
            Spacer()
            
            Text("허가한 권한은 언제든지 iPhone 설정 앱에서 철회할 수 있어요\n추후 권한 수정이 필요한 경우 앱 내 권한 페이지에서 수정 가능해요")
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.bottom, 10)
            
            Button {
                dismiss()
            } label: {
                Text("완료했어요")
                    .standardButtonText()
            }
            .standardButton()
        }
    }
}

#Preview {
    @ObservedObject var mapViewModel = MapViewModel()
    
    return Group {
        PermissionView(isPresented: .constant(true), mapViewModel: mapViewModel)
            .padding()
    }
}
