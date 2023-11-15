//
//  SearchBar.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String
    @Binding var isEditing: Bool
    
    var body: some View {
        HStack {
            TextField("검색", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                 
//                        if isEditing {
//
//                        }
                        
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    // self.isEditing = true
                }
                .onAppear {
                    UITextField.appearance().clearButtonMode = .never
                }
 
//            if isEditing {
//
//            }
            
            Button(action: {
                withAnimation(.spring, {
                    self.isEditing = false
                })
                self.text = ""
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                GATracking.sendLogEvent(eventName: GATracking.MainViewMessage.SEARCH_CANCEL, params: nil)
            }) {
                Text("취소")
            }
            .padding(.trailing, 10)
            .transition(.move(edge: .trailing))
            .animation(.default, value: 0.3)
        }
    }
}

#Preview {
    SearchBar(text: .constant(""), isEditing: .constant(true))
        .border(Color.black)
}
