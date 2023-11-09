//
//  PermissionView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct PermissionView: View {
    
    // Environment
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    
    var body: some View {
        Text("PermissionView")
        
        Button("close") {
            isPresented = false
        }
        
        Button("dismiss") {
            dismiss()
        }
    }
}

#Preview {
    PermissionView(isPresented: .constant(true))
        .padding()
}
