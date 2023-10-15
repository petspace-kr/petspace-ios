//
//  StoreDetaiView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 10/15/23.
//

import SwiftUI

struct StoreDetailView: View {
    
    var storeData: StoreModel
    
    var body: some View {
        
        ZStack {
            VStack {
                AsyncImage(url: URL(string: storeData.iconImage)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 500)
                    .background(Color.gray)
                
                Spacer()
            }
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false, content: {
                Spacer()
                    .frame(width: 200, height: 460)
                
                VStack {
                    Text(storeData.name)
                        .font(.title3)
                        .bold()
                    
                    Text(storeData.address)
                        .font(.system(size: 14))
                    
                    Spacer()
                        .frame(width: 200, height: 700)
                }
                .background(Color.white)
            })
            
            VStack {
                HStack {
                    Button {

                    } label: {
                        Label("뒤로가기", systemImage: "chevron.backward")
                            .font(.system(size: 20))
                    }
                    Spacer()
                    Button {

                    } label: {
                        Label("", systemImage: "xmark")
                            .font(.system(size: 20))
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .background(.clear)
        }
        
//        ScrollView {
//            VStack {
//                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
//                    AsyncImage(url: URL(string: storeData.iconImage)) { image in
//                            image
//                                .resizable()
//                                .scaledToFill()
//                        } placeholder: {
//                            ProgressView()
//                        }
//                        .frame(height: 500)
//                        .background(Color.gray)
//                    
//                    Rectangle()
//                        .foregroundColor(.clear)
//                        .frame(height: 150)
//                        .background(
//                            LinearGradient(
//                                stops: [
//                                    Gradient.Stop(color: .black.opacity(0), location: 0.06),
//                                    Gradient.Stop(color: .black, location: 1.00),
//                                ],
//                                startPoint: UnitPoint(x: 0.5, y: 0),
//                                endPoint: UnitPoint(x: 0.5, y: 1)
//                            )
//                        )
//                    
//                    VStack(alignment: .center, content: {
//                        
//                        HStack {
//                            Button {
//                                
//                            } label: {
//                                Label("뒤로가기", systemImage: "chevron.backward")
//                                    .font(.system(size: 20))
//                            }
//                            Spacer()
//                            Button {
//                                
//                            } label: {
//                                Label("", systemImage: "xmark")
//                                    .font(.system(size: 20))
//                            }
//                        }
//                        .padding(.top, 40)
//                        
//                        Spacer()
//                        
//                        Text(storeData.name)
//                            .foregroundStyle(.white)
//                            .font(.system(size: 20))
//                            .bold()
//                        
//                        if storeData.rating < 0 {
//                            Text(storeData.address)
//                                .font(.system(size: 14))
//                                .foregroundStyle(.white)
//                                
//                        } else {
//                            Text("✦ \(String(format: "%.1f", storeData.rating)) ∙ " + storeData.address)
//                                .font(.system(size: 14))
//                                .foregroundStyle(.white)
//                        }
//                    })
//                    .padding(.horizontal, 20)
//                    .padding(.vertical, 18)
//                }
//                .frame(height: 500)
//                
//                Text(storeData.description)
//                    .font(.system(size: 13))
//                
//                Spacer()
//            }
//        }
//        .ignoresSafeArea()
    }
}

#Preview {
    StoreDetailView(storeData: storeDatas[1])
}
