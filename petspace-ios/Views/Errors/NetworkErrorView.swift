//
//  NetworkErrorView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI
import Network

struct NetworkErrorView: View {
    
    // Environment
    @Environment(\.dismiss) var dismiss
    
    // 네트워크 검사 모니터
    @State private var monitor: NWPathMonitor? = nil
    
    // 네트워크 접속 가능 여부
    // 만약 네트워크는 접속이 가능하다면 서버 오류임
    @State private var isNetworkAvailable = true
    
    var body: some View {
        VStack(alignment: .center, content: {
            Image(systemName: isNetworkAvailable ? "exclamationmark.icloud.fill" : "network.slash")
                .resizable()
                .scaledToFit()
                .frame(width: 45, height: 45)
            
            Spacer()
                .frame(height: 20)
            
            Text(isNetworkAvailable ? "현재 펫스페이스 서버가 점검중이에요" : "서버에 접속할 수 없어요")
                .font(.system(size: 18))
                .bold()
            
            if !isNetworkAvailable {
                Spacer()
                    .frame(height: 3)
                
                Text("현재 네트워크가 불가능하여 서버에 연결할 수 없어요.")
                    .font(.system(size: 15))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
                .frame(height: 20)
            
            GroupBox {
                VStack(alignment: .leading, content: {
                    HStack {
                        Text(isNetworkAvailable ? "• 자세한 내용은 홈페이지를 참고해주세요. \n  (https://petspace.whitekiwi.link)" : "• 사용자의 기기가 셀룰러 혹은 와이파이를 통해 인터넷에 연결되어 있는지 확인해보세요.")
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.leading)
                        
                        if isNetworkAvailable {
                            Spacer()
                        }
                    }
                    
                    if !isNetworkAvailable {
                        Text("• 인터넷에 연결되어 있다면 펫스페이스 서버 문제일 수 있어요.")
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.leading)
                    }
                })
            }
        })
        .onAppear() {
            // 네트워크 모니터링 시작
            startMonitoring()
        }
        .onDisappear {
            // 뷰가 사라질 때 모니터링 중지
            stopMonitoring()
        }
    }
    
    func startMonitoring() {
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                isNetworkAvailable = path.status == .satisfied
                
                if isNetworkAvailable {
                    GATracking.sendLogEvent(eventName: GATracking.MainViewMessage.CANNOT_ACCESS_SERVER_ERROR, params: nil)
                }
            }
        }
    }

    func stopMonitoring() {
        monitor?.cancel()
    }
}

#Preview {
    VStack {
        NetworkErrorView()
            
        Spacer()
            .frame(height: 20)
        
        Button {
            
        } label: {
            Text("재시도")
                .font(.system(size: 15))
        }
        .buttonStyle(.borderedProminent)
    }
    .padding()
}
