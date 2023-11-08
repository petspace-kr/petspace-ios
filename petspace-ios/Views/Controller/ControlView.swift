//
//  ControlView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI
import CoreLocation

struct ControlView: View {
    
    @StateObject var viewModel = StoreViewModel()
    @StateObject var mapViewModel = MapViewModel()
    
    var body: some View {
        Text("\(viewModel.store.count) stores loaded")
    }
}

#Preview {
    ControlView()
}
