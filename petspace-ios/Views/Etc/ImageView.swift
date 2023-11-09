//
//  ImageView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct ImageView: View {
    
    @State var storeItem: Store.Data.StoreItem
    
    var body: some View {
        Text("ImageView")
    }
}

#Preview {
    @ObservedObject var storeViewModel = StoreViewModel()
    
    return Group {
        ImageView(storeItem: storeViewModel.store[0])
    }
    
}
