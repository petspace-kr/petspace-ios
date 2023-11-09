//
//  NetworkErrorView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct NetworkErrorView: View {
    
    // Environment
    @Environment(\.dismiss) var dismiss
    @State var isServerError: Bool = false
    
    var body: some View {
        VStack(alignment: .center, content: {
            Image(systemName: "network.slash")
                .resizable()
                .frame(width: 45, height: 45)
            
            Spacer()
                .frame(height: 20)
            
            Text(isServerError ? "현재 펫스페이스 서버가 점검중이에요" : "네트워크가 불가능해요")
                .font(.system(size: 18))
                .bold()
            
            if !isServerError {
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
                        Text(isServerError ? "• 자세한 내용은 홈페이지를 참고해주세요." : "• 사용자의 기기가 셀룰러 혹은 와이파이를 통해 인터넷에 연결되어 있는지 확인해보세요.")
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.leading)
                        
                        if isServerError {
                            Spacer()
                        }
                    }
                    
                    if !isServerError {
                        Text("• 인터넷에 연결되어 있다면 펫스페이스 서버 문제일 수 있어요.")
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.leading)
                    }
                })
            }
        })
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

#Preview {
    VStack {
        NetworkErrorView(isServerError: true)
            
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
