//
//  SettingView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        VStack {
            HStack {
                Text("설정")
                    .font(.title)
                    .bold()
                
                Spacer()
            }
            
            Spacer()
                .frame(height: 30)
            
            ScrollView {
                Text("설정")
            }
        }
    }
}

#Preview {
    SettingView()
        .padding()
}
