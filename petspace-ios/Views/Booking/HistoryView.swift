//
//  HistoryView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        VStack {
            HStack {
                Text("내 예약")
                    .font(.title)
                    .bold()
                    .padding(.leading, 6)
                
                Spacer()
                
            }
            
            Spacer()
            
            Text("최근 1년 내 예약 내역이 없어요")
                .font(.system(size: 15))
                .foregroundStyle(.gray)
            
            Spacer()
        }
    }
}

#Preview {
    HistoryView()
        .padding()
}
