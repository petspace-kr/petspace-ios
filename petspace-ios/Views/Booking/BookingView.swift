//
//  BookingView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct BookingView: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("예약하기")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button {
                    self.isPresented = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.primary)
                }
            }
            
            Text("애견미용실 소개")
                .font(.headline)
                .bold()
            
            Spacer()
        }
        .padding()
        .padding(.horizontal, 6)
    }
}

#Preview {
    
    return Group {
        Text("")
            .sheet(isPresented: .constant(true), content: {
                BookingView(isPresented: .constant(true))
            })
    }
    
}
