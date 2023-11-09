//
//  PermissionView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct PermissionView: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        Text("PermissionView")
        
        Button("close") {
            isPresented = false
        }
    }
}

#Preview {
    PermissionView(isPresented: .constant(true))
        .padding()
}
