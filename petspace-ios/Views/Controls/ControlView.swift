//
//  ControlView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI
import CoreLocation

struct ControlView: View {
    
    // ViewModels
    @StateObject var viewModel = StoreViewModel()
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
            Group {
                // 첫 접속이라면
                if isFirst {
                    LoadingView()
                        .onAppear() {
                            checkNetwork()
                            isWelcomeViewPresented = true
                            ServerLogger.sendLog(group: "TEST_LOG", message: "WELCOME_FIRST_APP_OPEN")
                        }
                }
                
                // 첫 접속이 아니라면
                else {
                    if isLoading {
                        LoadingView()
                            .onAppear() {
                                checkNetwork()
                            }
                    }
                    else {
                        // if redraw
//                        MapStoreListView(isRedraw: $isRedraw)
//                            .environment(staticModelData)
//                            .onAppear() {
//                                staticMapViewModel.checkLocationServiceEnabled()
//                                staticMapViewModel.startTimer()
//                            }
//                            .onDisappear() {
//                                staticMapViewModel.fireTimer()
//                            }
                        
                        Text("MapStoreListView")
                        
                    }
                }
            }
            .fullScreenCover(isPresented: $isWelcomeViewPresented, onDismiss: {
                checkNetwork()
            }, content: {
                // WelcomeView(isPresented: $isWelcomeViewPresented, isRedraw: $isRedraw, isWelcome: true)
                Text("WelcomeView")
            })
        }
    }
    
    func checkNetwork() {
        isFirst = !UserDefaults.standard.bool(forKey: "hasShownWelcomeView")
        
        let url = URL(string: ServerURLCollection.healthCheck.rawValue)!
        
        sleep(1)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
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
    
    func firstLoading() {
        // download data
    }
}

#Preview {
    ControlView()
}
