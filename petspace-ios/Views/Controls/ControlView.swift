//
//  ControlView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI
import CoreLocation
import Network
import FirebaseAnalyticsSwift

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
                .onAppear() {
                    // View 방문 이벤트
                    GATracking.eventScreenView(screenName: GATracking.ScreenNames.networkErrorView)
                }
            
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
            // 첫 접속이라면
            if isFirst {
                AppLoadingView()
                    .onAppear() {
                        checkNetwork()
                        isWelcomeViewPresented = true
                        // View 방문 이벤트
                        GATracking.eventScreenView(screenName: GATracking.ScreenNames.appLoadingView)
                    }
                    .fullScreenCover(isPresented: $isWelcomeViewPresented, onDismiss: {
                        checkNetwork()
                    }, content: {
                        WelcomeView(isPresented: $isWelcomeViewPresented, mapViewModel: mapViewModel, profileViewModel: profileViewModel, isWelcome: true)
                            .onAppear() {
                                GATracking.sendLogEvent(eventName: GATracking.RegisterStepsMessage.WELCOME_FIRST_APP_OPEN, params: nil)
                                // View 방문 이벤트
                                GATracking.eventScreenView(screenName: GATracking.ScreenNames.welcomeView)
                            }
                    })
            }
            
            // 첫 접속이 아니라면 
            else {
                if isLoading {
                    AppLoadingView()
                        .onAppear() {
                            checkNetwork()
                            // View 방문 이벤트
                            GATracking.eventScreenView(screenName: GATracking.ScreenNames.appLoadingView)
                        }
                }
                else {
                    /* MapStoreListView(storeViewModel: storeViewModel, mapViewModel: mapViewModel, profileViewModel: profileViewModel)
                        .onAppear() {
                            mapViewModel.checkLocationServiceEnabled()
                            GATracking.sendLogEvent(eventName: GATracking.MainViewMessage.APP_OPEN, params: nil)
                            // View 방문 이벤트
                            GATracking.eventScreenView(screenName: GATracking.ScreenNames.mainView)
                        }*/
                    Text("MapStoreListView Deprecated")
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
                    print("server healthy check: \(data)")
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

//#Preview {
//    ControlView()
//}

// deprecated
struct ControlViewV2: View {
    
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
                .onAppear() {
                    // View 방문 이벤트
                    GATracking.eventScreenView(screenName: GATracking.ScreenNames.networkErrorView)
                }
            
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
            // 첫 접속이라면
            if isFirst {
                AppLoadingView()
                    .onAppear() {
                        checkNetwork()
                        isWelcomeViewPresented = true
                        // View 방문 이벤트
                        GATracking.eventScreenView(screenName: GATracking.ScreenNames.appLoadingView)
                    }
                    .fullScreenCover(isPresented: $isWelcomeViewPresented, onDismiss: {
                        checkNetwork()
                    }, content: {
                        WelcomeView(isPresented: $isWelcomeViewPresented, mapViewModel: mapViewModel, profileViewModel: profileViewModel, isWelcome: true)
                            .onAppear() {
                                GATracking.sendLogEvent(eventName: GATracking.RegisterStepsMessage.WELCOME_FIRST_APP_OPEN, params: nil)
                                // View 방문 이벤트
                                GATracking.eventScreenView(screenName: GATracking.ScreenNames.welcomeView)
                            }
                    })
            }
            
            // 첫 접속이 아니라면
            else {
                if isLoading {
                    AppLoadingView()
                        .onAppear() {
                            checkNetwork()
                            // View 방문 이벤트
                            GATracking.eventScreenView(screenName: GATracking.ScreenNames.appLoadingView)
                        }
                }
                else {
                    TabView {
                        /* MapStoreListViewV2(storeViewModel: storeViewModel, mapViewModel: mapViewModel, profileViewModel: profileViewModel)*/
                        Text("MapStoreListViewV2 Deprecated")
                            .tabItem {
                                Label("찾아보기", systemImage: "map")
                            }
                            .onAppear() {
                                mapViewModel.checkLocationServiceEnabled()
                                GATracking.sendLogEvent(eventName: GATracking.MainViewMessage.APP_OPEN, params: nil)
                                // View 방문 이벤트
                                GATracking.eventScreenView(screenName: GATracking.ScreenNames.mainView)
                            }
                        
                        Text("Tab2")
                            .tabItem {
                                Label("프로필", systemImage: "dog.circle")
                            }
                        
                        Text("Tab3")
                            .tabItem {
                                Label("예약", systemImage: "book.circle")
                            }
                            .badge(3)
                        
                        Text("Tab4")
                            .tabItem {
                                Label("설정", systemImage: "gear")
                            }
                    }
                    .tabViewStyle(.automatic)
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
                    print("server healthy check: \(data)")
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

//#Preview {
//    ControlViewV2()
//}

struct ControlViewV3: View {
    
    // ViewModels
    @StateObject var storeViewModel = StoreViewModel()
    @StateObject var mapViewModel = MapViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    
    // State
    @State private var isError: Bool = false
    @State private var isLoading: Bool = true
    @State private var isFirst: Bool = false
    @State private var isDataLoading: Bool = false
    
    // presented variable
    @State var isWelcomeViewPresented: Bool = false
    
    var body: some View {
        if isError {
            NetworkErrorView()
                .padding()
                .onAppear() {
                    // View 방문 이벤트
                    GATracking.eventScreenView(screenName: GATracking.ScreenNames.networkErrorView)
                }
            
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
            // 첫 접속이라면
            if isFirst {
                AppLoadingView()
                    .onAppear() {
                        checkNetwork()
                        isWelcomeViewPresented = true
                        // View 방문 이벤트
                        GATracking.eventScreenView(screenName: GATracking.ScreenNames.appLoadingView)
                    }
                    .fullScreenCover(isPresented: $isWelcomeViewPresented, onDismiss: {
                        checkNetwork()
                    }, content: {
                        WelcomeView(isPresented: $isWelcomeViewPresented, mapViewModel: mapViewModel, profileViewModel: profileViewModel, isWelcome: true)
                            .onAppear() {
                                GATracking.sendLogEvent(eventName: GATracking.RegisterStepsMessage.WELCOME_FIRST_APP_OPEN, params: nil)
                                // View 방문 이벤트
                                GATracking.eventScreenView(screenName: GATracking.ScreenNames.welcomeView)
                            }
                    })
            }
            
            // 첫 접속이 아니라면
            else {
                if isLoading {
                    AppLoadingView()
                        .onAppear() {
                            checkNetwork()
                            // View 방문 이벤트
                            GATracking.eventScreenView(screenName: GATracking.ScreenNames.appLoadingView)
                        }
                }
                else {
                    TabView {
                        ZStack {
                            MapViewV2(storeViewModel: storeViewModel, mapViewModel: mapViewModel, profileViewModel: profileViewModel)
                            
                            VStack {
                                Spacer()
                                    .frame(height: 20)
                                
                                HStack {
                                    Spacer()
                                        .frame(width: 20)
                                    
                                    HStack {
                                        Text("PETSPACE")
                                            .multilineTextAlignment(.center)
                                            .font(.title3)
                                            .bold()
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 10)
                                        
                                        if isDataLoading {
                                            ProgressView()
                                            
                                            Spacer()
                                                .frame(width: 12)
                                        }
                                    }
                                    .materialBackground()
                                    .onTapGesture {
                                        isDataLoading = true
                                        storeViewModel.loadStoreListDataV2(dogBreed: profileViewModel.selectedProfile.dogName, dogWeight: profileViewModel.selectedProfile.dogWeight) {
                                            sleep(1)
                                            print("data all loaded")
                                            isDataLoading = false
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                
                                Spacer()
                            }
                        }
                        .tabItem {
                            Label("둘러보기", systemImage: "map.circle.fill")
                        }
                        .onAppear() {
                            mapViewModel.checkLocationServiceEnabled()
                            GATracking.sendLogEvent(eventName: GATracking.MainViewMessage.APP_OPEN, params: nil)
                            // View 방문 이벤트
                            GATracking.eventScreenView(screenName: GATracking.ScreenNames.mainView)
                        }
                        
                        StoreListViewV3(mapViewModel: mapViewModel, storeViewModel: storeViewModel, profileViewModel: profileViewModel)
                            .tabItem {
                                Label("미용실", systemImage: "storefront.circle.fill")
                            }
                        
//                        ProfileView(isPresented: .constant(true), isEditing: false, isFirstRegister: false, profileViewModel: profileViewModel, mapViewModel: mapViewModel)
                        // .padding()
                         ProfileListView(profileViewModel: profileViewModel)
                        // ProfileTestView(profileViewModel: profileViewModel)
                            .tabItem {
                                Label("프로필", systemImage: "dog.circle.fill")
                            }
                        
                        HistoryView()
                            .tabItem {
                                Label("예약", systemImage: "book.circle.fill")
                            }
                            .badge(0)
                        
                        SettingView(profileViewModel: profileViewModel)
                            .tabItem {
                                Label("설정", systemImage: "gearshape.circle.fill")
                            }
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
                    print("server healthy check: \(data)")
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
    ControlViewV3()
}
