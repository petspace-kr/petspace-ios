//
//  DetailView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct DetailView: View {
    
    // Environment
    @Environment(\.dismiss) var dismiss
    @State var storeItem: Store.Data.StoreItem
    
    // 현재 뷰 Presented
    @Binding var isPresented: Bool
    
    // 이미지 뷰 Presented
    @State private var isImageViewPresented: Bool = false
    
    // 프로필 뷰 모델
    @ObservedObject var profileViewModel: ProfileViewModel
    
    // Map View Model
    @ObservedObject var mapViewModel: MapViewModel
    
    // 세부 정보 표시 여부
    @State private var isPriceTableShowing: Bool = false
    @State private var isMapShowing: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    DetailTitleImageView(storeItem: storeItem, isPresented: $isPresented)
                    
                    VStack(alignment: .leading) {
                        
                        Spacer()
                            .frame(height: 10)
                        
                        Text("애견미용실 소개")
                            .font(.headline)
                            .bold()
                        
                        Spacer()
                            .frame(height: 10)
                        
                        Text(storeItem.description)
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                            .frame(height: 30)
                        
                        // 연락처 있는 경우
                        if storeItem.tel != "" {
                            Text("연락처")
                                .font(.headline)
                                .bold()
                            
                            Spacer()
                                .frame(height: 10)
                            
                            Button {
                                // 전화 걸기
                                let formattedString = "tel://" + storeItem.tel
                                print(formattedString)
                                guard let phoneUrl = URL(string: formattedString) else { return }
                                UIApplication.shared.open(phoneUrl)
                                GATracking.sendLogEvent(eventName: GATracking.DetailViewMessage.DETAIL_PAGE_CALL_CLICK, params: nil)
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .fill(Color("Background1"))
                                        .stroke(Color("Stroke1"), lineWidth: 1)
                                    
                                    HStack {
                                        Spacer()
                                            .frame(width: 15)
                                        
                                        Image(systemName: "phone.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundStyle(Color("Foreground1"))
                                        
                                        Spacer()
                                            .frame(width: 10)
                                        
                                        Text(storeItem.tel.prettyPhoneNumber())
                                            .foregroundStyle(Color("Foreground1"))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(Color("Foreground1"))
                                        
                                        Spacer()
                                            .frame(width: 10)
                                    }
                                }
                                .frame(height: 48)
                            }
                            
                            Spacer()
                                .frame(height: 30)
                        }
                        
                        Text("✲ 프로필 맞춤 가격")
                            .font(.headline)
                            .foregroundColor(Color(red: 0, green: 0.64, blue: 1))
                            .bold()
                        
                        Spacer()
                            .frame(height: 10)
                        
                        if profileViewModel.dogProfile.count > 0 {
                            ZStack {
                                RoundedRectangle(cornerRadius: .infinity)
                                    .fill(Color("Background1"))
                                    .stroke(Color("Stroke1"), lineWidth: 1)
                                
                                Menu {
                                    Section("프로필을 선택하세요") {
                                        ForEach (Array(profileViewModel.dogProfile.enumerated()), id: \.offset) { index, profile in
                                            Button("\(profile.dogName) - \(profile.dogBreed)") {
                                                // 프로필 변경 코드 작성
                                                profileViewModel.selectedProfileIndex = index
                                            }
                                        }
                                    }
                                } label: {
                                    HStack {
                                        if let imageData = profileViewModel.dogProfile[profileViewModel.selectedProfileIndex].profileImageData {
                                            if let image = imageData.decodeToImage() {
                                                Spacer()
                                                    .frame(width: 8)
                                                
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 36, height: 36)
                                                    .clipShape(Circle())
                                                
                                                Spacer()
                                                    .frame(width: 12)
                                            } else {
                                                Spacer()
                                                    .frame(width: 20)
                                            }
                                        }
                                         else {
                                            Spacer()
                                                .frame(width: 20)
                                        }
                                        
                                        Text("\(profileViewModel.dogProfile[profileViewModel.selectedProfileIndex].dogName)")
                                            .font(.system(size: 18))
                                            .bold()
                                            .fixedSize(horizontal: true, vertical: true)
                                            .foregroundStyle(Color("Foreground1"))
                                        
                                        Text("\(profileViewModel.dogProfile[profileViewModel.selectedProfileIndex].dogBreed) ∙ \(String(format: "%.1f", profileViewModel.dogProfile[profileViewModel.selectedProfileIndex].dogWeight))kg")
                                            .fixedSize(horizontal: true, vertical: true)
                                            .foregroundStyle(Color("Foreground1"))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(Color("Foreground1"))
                                        
                                        Spacer()
                                            .frame(width: 10)
                                    }
                                    .padding(.leading, 0)
                                    .padding(.trailing, 10)
                                }
                                .frame(height: 48)
                            }
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 10.0)
                                    .fill(Color("Background1"))
                                    .stroke(Color("Stroke1"), lineWidth: 1)
                                
                                VStack(alignment: .leading) {
                                    Text("미용")
                                        .font(.headline)
                                        .bold()
                                    
                                    HStack {
                                        Text("일반컷")
                                            .font(.system(size: 15))
                                        
                                        Spacer()
                                        
                                        Text("\(storeItem.pricing.cut)")
                                            .font(.system(size: 15))
                                    }
                                    .padding(.top, 10)
                                    
                                    
                                    HStack {
                                        Text("가위컷")
                                            .font(.system(size: 15))
                                        
                                        Spacer()
                                        
                                        Text("\(storeItem.pricing.cut + 10000)")
                                            .font(.system(size: 15))
                                    }
                                    .padding(.top, 2)
                                    
                                }
                                .padding(.vertical, 20)
                                .padding(.horizontal, 16)
                            }
                            
                            HStack {
                                Spacer()
                                Text("곧, 모든 종류의 서비스(미용 및 스파) 가격 정보를 제공할 예정이에요.")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            .padding(.top, 2)
                            
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10.0)
                                    .fill(Color("Background1"))
                                    .stroke(Color("Stroke1"), lineWidth: 1)
                                    .frame(height: 100)
                                
                                Text("프로필을 등록하면 맞춤형 가격을 바로 확인할 수 있어요")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.gray)
                            }
                        }
                        
                        Spacer()
                            .frame(height: 30)
                        
                        Text("미용실 정보")
                            .font(.headline)
                            .bold()
                        
//                        GroupBox {
//
//                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(Color("Background1"))
                                .stroke(Color("Stroke1"), lineWidth: 1)
                            
                            Button {
                                withAnimation(.spring) {
                                    isPriceTableShowing.toggle()
                                }
                                GATracking.sendLogEvent(eventName: GATracking.DetailViewMessage.DETAIL_PAGE_SHOW_PRICE_TABLE, params: nil)
                            } label: {
                                HStack {
                                    Label("가격표 보기", systemImage: "table")
                                        .foregroundStyle(Color("Foreground1"))
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundStyle(Color("Foreground1"))
                                        .rotationEffect(.degrees(isPriceTableShowing ? 0 : -90))
                                }
                                .foregroundStyle(Color("MainForeground"))
                                .padding(.horizontal, 10)
                                
                            }
                            .frame(height: 48)
                        }
                        
                        if isPriceTableShowing {
                            GroupBox {
                                AsyncImage(url: URL(string: storeItem.pricingImage)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                // .frame(width: geometry.size.width - 60)
                                .background(Color.gray)
                                .cornerRadius(10)
                                .clipped()
                                .onTapGesture {
                                    isImageViewPresented = true
                                }
                                .sheet(isPresented: $isImageViewPresented, onDismiss: {
                                    
                                }) {
                                    ImageView(isPresented: $isImageViewPresented, storeItem: storeItem)
                                        .onAppear() {
                                            // View 방문 이벤트
                                            GATracking.eventScreenView(screenName: GATracking.ScreenNames.imageView)
                                        }
                                        .onDisappear() {
                                            // View 방문 이벤트
                                            GATracking.eventScreenView(screenName: GATracking.ScreenNames.detailView)
                                        }
                                }
                            }
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(Color("Background1"))
                                .stroke(Color("Stroke1"), lineWidth: 1)
                            
                            Button {
                                withAnimation(.spring) {
                                    isMapShowing.toggle()
                                }
                                GATracking.sendLogEvent(eventName: GATracking.DetailViewMessage.DETAIL_PAGE_SHOW_MINIMAP, params: nil)
                            } label: {
                                HStack {
                                    Label("지도에서 위치 보기", systemImage: "mappin.and.ellipse")
                                        .foregroundStyle(Color("Foreground1"))
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundStyle(Color("Foreground1"))
                                        .rotationEffect(.degrees(isMapShowing ? 0 : -90))
                                }
                                .foregroundStyle(Color("MainForeground"))
                                .padding(.horizontal, 10)
                            }
                            .frame(height: 48)
                        }
                        
                        if isMapShowing {
                            MapOneView(storeItem: storeItem, mapViewModel: mapViewModel, profileViewModel: profileViewModel)
                        }
                        
                        Spacer()
                            .frame(height: 30)
                        
                        if storeItem.images.count > 0 {
                            Text("미용실 사진")
                                .font(.headline)
                                .bold()
                            
                            TabView {
                                ForEach(storeItem.images, id: \.self) { image in
                                    AsyncImage(url: URL(string: image)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .clipped()
                                }
                            }
                            .tabViewStyle(.page)
                            .indexViewStyle(.page(backgroundDisplayMode: .always))
                            .frame(height: 250)
                            
                            Spacer()
                                .frame(height: 30)
                        }
                        
                        Text("리뷰")
                            .font(.headline)
                            .bold()
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10.0)
                                .fill(Color("Background1"))
                                .stroke(Color("Stroke1"), lineWidth: 1)
                                .frame(height: 180)
                            
                            Text("아직 작성된 리뷰가 없어요")
                                .font(.system(size: 15))
                                .foregroundStyle(.gray)
                        }
                        
                        
                        Spacer()
                            .frame(height: 20)
                        
                        Button("아직 예약이 불가능한 미용실이에요") {
                            
                        }
                        .bigButton()
                        .disabled(true)
                        .padding()
                    } // End of VStack
                    .padding(12)
                    
                } // End of ScrollView
                .padding(0)
                
            } // End of VStack
            .padding(0)
        }
    }
}

struct DetailTitleImageView: View {
    
    // Environment
    @Environment(\.dismiss) var dismiss
    @State var storeItem: Store.Data.StoreItem
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: storeItem.iconImage)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .background(Color.gray)
            .clipped()
            
            // 그라데이션
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 120)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: .black.opacity(0), location: 0.06),
                            Gradient.Stop(color: .black.opacity(0.8), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    )
                )
            
            VStack(alignment: .leading) {
                HStack {
                    // 저장 버튼
                    /* Button {
                        storeData.updateSaved()
                    } label: {
                        if let saved = storeData.isSaved {
                            Image(systemName: saved ? "heart.fill" : "heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                        }
                    } */
                    
                    Spacer()
                    
                    Button {
                        self.isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                Spacer()
                
                HStack {
                    
                    Spacer()
                        .frame(width: 20)
                    
                    Text("\(storeItem.name)")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                
                Spacer()
                    .frame(height: 4)
                
                HStack {
                    
                    Spacer()
                        .frame(width: 20)
                    
                    if storeItem.rating <= 0 {
                        Text("\(storeItem.address)")
                            .font(.system(size: 14))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.white)
                    }
                    else {
                        Text("✦ \(String(format: "%.1f", storeItem.rating)) ∙ \(storeItem.address)")
                            .font(.system(size: 14))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                
                Spacer()
                    .frame(height: 20)
            }
        }
    }
}

#Preview {
    @ObservedObject var mapViewModel = MapViewModel()
    @ObservedObject var storeViewModel = StoreViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    return Group {
        Text("")
            .sheet(isPresented: .constant(true), content: {
                DetailView(storeItem: storeViewModel.store[2], isPresented: .constant(true), profileViewModel: profileViewModel, mapViewModel: mapViewModel)
                    .background(Color("Background2"))
            })
    }
}

