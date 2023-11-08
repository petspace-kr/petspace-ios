//
//  CloseKeyboardButton.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct CloseKeyboardButton: View {
    var body: some View {
        Button {
            print("keyboard down button pressed")
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(.clear)
                    .frame(width: 36, height: 36)
                    .shadow(radius: 2)
                    .overlay {
                        Circle()
                            .stroke(.gray, lineWidth: 1)
                    }
                    
                
                Image(systemName: "keyboard.chevron.compact.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22)
                    .foregroundColor(.secondary)
            }
            .frame(width: 36, height: 36)
        }
    }
}

#Preview {
    ZStack {
        CloseKeyboardButton()
    }
    
}
