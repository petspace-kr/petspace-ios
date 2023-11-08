//
//  LoadingView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("AppLogo")
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(30)
                .padding(.top, 40)
                .padding(.bottom, 10)
            
            Text("PETSPACE")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            
            ProgressView()
            
            Spacer()
            
            Text("ⓒ 2023 TEAM PETSPACE")
                .font(.system(size: 14))
                .foregroundStyle(.gray)
                .padding(.bottom, 4)
        }
    }
}

#Preview {
    LoadingView()
}
