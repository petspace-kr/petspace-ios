//
//  HistoryView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        NavigationStack {
            HStack {
                Text("내 예약")
                    .font(.title)
                    .bold()
                    .padding(.leading, 6)
                
                Spacer()
                
                Button("편집") {
                    
                }
                .padding(.trailing, 6)
            }
            
            Spacer()
                .frame(height: 30)
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("진행중인 예약")
                        .font(.headline)
                        .bold()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(Color("Background1"))
                            .stroke(Color("Stroke1"), lineWidth: 1)
                            .frame(height: 180)
                        
                        Text("진행중인 예약이 없어요")
                            .font(.system(size: 15))
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Text("지난 예약")
                        .font(.headline)
                        .bold()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(Color("Background1"))
                            .stroke(Color("Stroke1"), lineWidth: 1)
                            .frame(height: 240)
                        
                        Text("최근 1년 내 예약 내역이 없어요")
                            .font(.system(size: 15))
                            .foregroundStyle(.gray)
                    }
                    
                }
            }
        }
        .padding()
    }
}

#Preview {
    HistoryView()
}
