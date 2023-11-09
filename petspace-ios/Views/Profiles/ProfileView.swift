//
//  ProfileView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/7/23.
//

import SwiftUI

struct ProfileView: View {
    
    // Environment
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    
    var body: some View {
        Text("ProfileView")
        
        Button("close") {
            isPresented = false
        }
        
        Button("dismiss") {
            dismiss()
        }
    }
}

#Preview {
    ProfileView(isPresented: .constant(true))
}
