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
    // var storeData: StoreModel
    @Environment(StoreDatas.self) var storeDatas
    var storeData: StoreModel
    
    var storeIndex: Int {
        storeDatas.items.firstIndex(where: { $0.id == storeData.id })!
    }
    
    var body: some View {
        @Bindable var storeDatas = storeDatas
        
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
                    if storeData.rating < 0 {
                        Text("리뷰 \(storeData.reviewCount)개")
                            .font(.system(size: 10))
                            .padding(0)
                    }
                    else {
                        Text("✦ \(String(format: "%.1f", storeData.rating)) ∙ 리뷰 \(storeData.reviewCount)개")
                            .font(.system(size: 10))
                            .padding(0)
                    }
                }
                
                // Store Description
                Text(storeData.description)
                    .font(.system(size: 10))
                    .foregroundStyle(.gray)
                    .lineLimit(1) // 텍스트가 한 줄로 제한
                    .truncationMode(.tail) // 끝에 ... 추가
                
                Button {
                    //
                } label: {
                    ZStack(alignment: .leading, content: {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 35)
                            .background(Color("SecondaryBackground"))
                            .cornerRadius(17.5)
                        
                        HStack {
                            Image("ProfileExample")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, content: {
                                Text("✲ 프로필 맞춤")
                                    .font(.system(size: 10))
                                    .foregroundColor(Color(red: 0, green: 0.64, blue: 1))
                                Text("커트 \(storeData.pricing.cut)원~")
                                    .font(.system(size: 10))
                                    .foregroundColor(Color("PrimaryColor"))
                            })
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 10)
                        }
                    })
                }
            })
        })
    }
}

#Preview {
    Group {
        StoreItem(storeData: StoreDatas().items[0])
            .border(Color.black)
        StoreItem(storeData: StoreDatas().items[1])
            .border(Color.black)
        StoreItem(storeData: StoreDatas().items[2])
            .border(Color.black)
    }
    .padding(.horizontal, 10)
}
