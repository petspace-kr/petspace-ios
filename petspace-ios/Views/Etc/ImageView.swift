//
//  ImageView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct ImageView: View {
    
    // Environment
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    @State var storeItem: Store.Data.StoreItem
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }
            }
            .padding(.trailing, 16)
            .padding(.top, 16)
            
            Spacer()
            
            AsyncImage(url: URL(string: storeItem.pricingImage)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            
            Spacer()
        }
        .background(.black)
    }
}

#Preview {
    @ObservedObject var storeViewModel = StoreViewModel()
    
    return Group {
        ImageView(isPresented: .constant(true), storeItem: storeViewModel.store[0])
    }
    
}

struct SimpleImageView: View {
    
    // Environment
    @Environment(\.dismiss) var dismiss
    let imageUrl: String
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }
            }
            .padding(.trailing, 16)
            .padding(.top, 16)
            
            Spacer()
            
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            
            Spacer()
        }
        .background(.black)
    }
}

struct ImagePagingView: View {
    
    // Environment
    @Environment(\.dismiss) var dismiss
    @State var storeItem: Store.Data.StoreItem
    @State var selectedImage: String
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }
            }
            .padding(.trailing, 16)
            .padding(.top, 16)
            
            Spacer()
            
            TabView(selection: $selectedImage) {
                ForEach(storeItem.images, id: \.self) { image in
                    AsyncImage(url: URL(string: image)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            Spacer()
        }
        .background(.black)
    }
}

#Preview {
    @ObservedObject var storeViewModel = StoreViewModel()
    
    return Group {
        ImagePagingView(storeItem: storeViewModel.store[0], selectedImage: storeViewModel.store[0].images[1])
    }
    
}
