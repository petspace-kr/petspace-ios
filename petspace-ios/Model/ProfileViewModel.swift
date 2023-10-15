//
//  ProfileViewModel.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 10/15/23.
//

import Foundation

final class ProfileViewModel: NSObject, ObservableObject {
    @Published var name: String = ""
}
