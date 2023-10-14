//
//  StoreItem.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 10/14/23.
//

import SwiftUI
import CoreLocation

struct StoreItem: View {
    @ObservedObject private var mapViewModel = MapViewModel()
    var storeData: StoreModel
    
    var body: some View {
        HStack(alignment: .center, content: {
            // Store Main Image
            AsyncImage(url: URL(string: storeData.iconImage)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 97, height: 113)
                .background(Color.gray)
                .cornerRadius(18)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4.0, content: {
                HStack {
                    // Store Title
                    Text(storeData.name)
                        .font(.system(size: 15))
                        .bold()
                    
                    Spacer()
                }
                
                // Store Address
                Text(storeData.address)
                    .font(.system(size: 12))
                
                let coordinate1 = Coordinate(latitude: mapViewModel.currentRegion.center.latitude, longitude: mapViewModel.currentRegion.center.longitude)
                let coordinate2 = Coordinate(latitude: storeData.coordinate.latitude, longitude: storeData.coordinate.longitude)
                let distanceKm = coordinate1.distance(to: coordinate2)
                
                // Store Score and Number of Reviews
                HStack {
                    Text("\(String(format: "%.2f", distanceKm))km")
                        .font(.system(size: 10))
                        .bold()
                        .padding(0)
                    Text("✦ \(String(format: "%.1f", storeData.rating)) ∙ 리뷰 \(storeData.reviewCount)개")
                        .font(.system(size: 10))
                        .padding(0)
                }
                
                // Store Description
                Text(storeData.description)
                    .font(.system(size: 10))
                    .foregroundStyle(.gray)
                    .lineLimit(1) // 텍스트가 한 줄로 제한
                    .truncationMode(.tail) // 끝에 ... 추가
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 35)
                        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                        .cornerRadius(17.5)
                        .overlay(
                    RoundedRectangle(cornerRadius: 17.5)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.96, green: 0.96, blue: 0.96), lineWidth: 1)
                    )
                }
            })
        })
    }
}

#Preview {
    Group {
        StoreItem(storeData: storeDatas[0])
        StoreItem(storeData: storeDatas[1])
        StoreItem(storeData: storeDatas[2])
    }
}
