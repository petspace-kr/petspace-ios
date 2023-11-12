//
//  ControlView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI
import CoreLocation
import Network

struct ControlView: View {
    
    // ViewModels
    @StateObject var storeViewModel = StoreViewModel()
    @StateObject var mapViewModel = MapViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    
    // State
    @State private var isError: Bool = false
    @State private var isLoading: Bool = true
    @State private var isFirst: Bool = false
    
    // presented variable
    @State var isWelcomeViewPresented: Bool = false
    
    var body: some View {
        if isError {
            NetworkErrorView()
                .padding()
            
            Spacer()
                .frame(height: 20)
            
            Button {
                isLoading = true
                isError = false
                checkNetwork()
            } label: {
                Text("재시도")
                    .font(.system(size: 15))
            }
            .buttonStyle(.borderedProminent)
        } else {
            if isFirst {
                AppLoadingView()
                    .onAppear() {
                        checkNetwork()
                        isWelcomeViewPresented = true
                        ServerLogger.sendLog(group: "TEST_LOG", message: "WELCOME_FIRST_APP_OPEN")
                    }
                    .fullScreenCover(isPresented: $isWelcomeViewPresented, onDismiss: {
                        checkNetwork()
                    }, content: {
                        WelcomeView(isPresented: $isWelcomeViewPresented, mapViewModel: mapViewModel, profileViewModel: profileViewModel, isWelcome: true)
                    })
            }
            
            // 첫 접속이 아니라면
            else {
                if isLoading {
                    AppLoadingView()
                        .onAppear() {
                            checkNetwork()
                        }
                }
                else {
                    MapStoreListView(storeViewModel: storeViewModel, mapViewModel: mapViewModel, profileViewModel: profileViewModel)
                        .onAppear() {
                            mapViewModel.checkLocationServiceEnabled()
                        }
                }
            }
        }
    }
    
    func checkNetwork() {
        isFirst = !UserDefaults.standard.bool(forKey: "hasShownWelcomeView")
        
        // 서버 접속 가능 여부 체크 API 주소
        let url = URL(string: ServerURLCollection.healthCheck.rawValue)!
        
        // Timeout Interval 설정 Request 인스턴스
        let request = URLRequest(url: url, timeoutInterval: 3000.0)
        
        sleep(1)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                isError = true
                isLoading = false
                return
            }
            
            guard let data = data else {
                print("No data received")
                isError = true
                isLoading = false
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                print(json?["data"]! ?? "No Data Received")
                if let data = json?["data"], data == "OK" {
                    isError = false
                } else {
                    isError = true
                }
            } catch {
                print("Error parsing JSON: \(error)")
                isError = true
            }
            
            isLoading = false
        }
        .resume()
    }
}

#Preview {
    ControlView()
}
