//
//  ProfileView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/7/23.
//

import SwiftUI

struct ProfileView: View {
    
    // Environment
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    
    // 수정 중 변수
    @State var isEditing: Bool
    
    // 첫 등록 관련 변수
    @State var isFirstEditing: Bool = false
    @State var isFirstRegister: Bool
    
    // View Models
    @ObservedObject var profileViewModel: ProfileViewModel
    
    // MapViewModel
    @ObservedObject var mapViewModel: MapViewModel
    
    // 프로필 경고 모달
    @State var isAlertShowing: Bool = false // 빈칸
    @State var isAlert1Presented: Bool = false // 프로필 등록 패스 모달
    @State var isAlert2Presented: Bool = false
    
    // 이미지 선택 관련 변수
    @State private var selectedImage: UIImage?
    @State private var showImagePicker: Bool = false
    
    // 키보드 Focus 상태 변수
    @FocusState private var isKeyboardFocused: Bool
    @FocusState private var isFocused: Int?
    
    // Text Field 편집용 변수
    @State private var dogName: String = ""
    @State private var dogBreed: String = ""
    @State private var dogSize: DogSize = .small
    @State private var dogWeight: String = ""
    @State private var dogBreedIndex: Int = -1
    
    // 현재 선택된 프로필 인덱스
    @State private var currentProfileIndex: Int = 0
    
    // 견종
    @State private var dogBreedData: DogBreed = load("dogbreed.json")
    private let dogSizeString: [String] = ["소형견", "중형견", "대형견"]
    
    var body: some View {
        VStack {
            HStack {
                Text(isFirstRegister ? "프로필을 등록해주세요" : (isEditing ? "프로필 수정" : "프로필"))
                    .font(.title)
                    .bold()
                    // .animation(.easeInOut(duration: 0.2))
                    .animation(.easeInOut, value: 0.2)
                
                Spacer()
                
                if isEditing && !isFirstRegister {
                    Button("취소") {
                        withAnimation(.easeInOut) {
                            isEditing = false
                        }
                        loadProfileData()
                        GATracking.sendLogEvent(eventName: GATracking.ProfileViewMessage.PROFILE_PAGE_EDIT_CANCEL_BUTTON, params: nil)
                    }
                    .disabled(isFirstEditing)
                    .padding(.trailing, 6)
                }
                
                if !isFirstRegister {
                    Button(isEditing ? "저장" : "편집") {
                        if isEditing {
                            let doubleWeight = Double(dogWeight)
                            
                            if doubleWeight == nil || doubleWeight! <= 0 {
                                isAlertShowing = true
                            } else {
                                // 프로필 저장
                                
                                // 비어 있다면 추가
                                if profileViewModel.dogProfile.isEmpty {
                                    profileViewModel.addProfile(dogName: dogName, dogBreed: dogBreed, dogSize: dogSize, dogWeight: doubleWeight!, profileImage: selectedImage)
                                    GATracking.sendLogEvent(eventName: GATracking.ProfileViewMessage.PROFILE_PAGE_SAVE, params: nil)
                                    
                                    let params = [
                                        "breed" : dogBreed,
                                        "size" : "\(dogSize.rawValue)",
                                        "weight" : dogWeight
                                    ]
                                    GATracking.sendLogEvent(eventName: GATracking.ProfileViewMessage.PROFILE_PAGE_SAVE_INFO, params: params)
                                    
                                    if selectedImage != nil {
                                        GATracking.sendLogEvent(eventName: GATracking.ProfileViewMessage.PROFILE_FIRST_IS_IMAGE_REGISTERED, params: nil)
                                    }
                                }
                                // 비어 있지 않다면 업데이트
                                else {
                                    profileViewModel.updateProfile(index: currentProfileIndex, dogName: dogName, dogBreed: dogBreed, dogSize: dogSize, dogWeight: doubleWeight!, profileImage: selectedImage)
                                    
                                    let params = [
                                        "breed" : dogBreed,
                                        "size" : "\(dogSize.rawValue)",
                                        "weight" : dogWeight
                                    ]
                                    GATracking.sendLogEvent(eventName: GATracking.ProfileViewMessage.PROFILE_PAGE_EDIT_INFO, params: params)
                                }
                                
                                withAnimation(.easeInOut) {
                                    isEditing = false
                                }
                                
                            }
                        }
                        else {
                            withAnimation(.easeInOut) {
                                isEditing = true
                            }
                            // 편집 시작
                            GATracking.sendLogEvent(eventName: GATracking.ProfileViewMessage.PROFILE_PAGE_EDIT_BUTTON, params: nil)
                        }
                    }
                    .disabled(isEditing && (dogName == "" || dogBreed == "" || dogWeight == ""))
                    /* .alert("모든 정보를 올바르게 입력해주세요", isPresented: $isAlertShowing) {
                        
                    }*/
                }
                
            }
            
            ScrollView {
                VStack(spacing: 20, content: {
                    
                    // 고양이 강아지
                    /* HStack {
                        Button {
                            dogSize = .small
                            dogBreed = ""
                            dogBreedIndex = -1
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10.0)
                                    .fill(Color.blue)
                                    .stroke(Color("Stroke1"), lineWidth: 1)
                                
                                HStack {
                                    Image(systemName: "cat")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(Color.primary)
                                    Text("고양이")
                                        .foregroundStyle(Color.primary)
                                }
                            }
                            .frame(height: 54)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button {
                            dogSize = .small
                            dogBreed = ""
                            dogBreedIndex = -1
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10.0)
                                    .fill(Color("Background1"))
                                    .stroke(Color("Stroke1"), lineWidth: 1)
                                
                                HStack {
                                    Image(systemName: "dog")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(Color.primary)
                                    Text("강아지")
                                        .foregroundStyle(Color.primary)
                                }
                            }
                            .frame(height: 54)
                        }
                        .frame(maxWidth: .infinity)
                    } */
                    
                    if isEditing {
                        ZStack {
                            Circle()
                                .fill(Color("Background2"))
                                .frame(width: 120, height: 120)
                            
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .animation(.spring, value: 0.1)
                            }
            
                            Button {
                                if selectedImage == nil {
                                    showImagePicker = true
                                }
                                else {
                                    withAnimation(.easeInOut) {
                                        selectedImage = nil
                                    }
                                }
                                
                            } label: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                                    .frame(width: 36)
                                    .rotationEffect(.degrees(selectedImage == nil ? 0 : 45))
                            }
                        }
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker(selectedImage: $selectedImage)
                        }
                        // .padding(.bottom, 10)
                    } else {
                        ZStack {
                            if let image = selectedImage {
                                Circle()
                                    .fill(Color("SecondaryBackground"))
                                    .frame(width: 120, height: 120)
                                
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .animation(.spring, value: 0.1)
                            }
                        }
                    }
                    
                    // 이름
                    VStack(alignment: .leading, content: {
                        Text("이름")
                        
                        GroupBox {
                            if isEditing {
                                TextField("강아지 이름을 입력해주세요", text: $dogName)
                                    .frame(height: 24)
                                    .foregroundColor(.primary)
                                    .onAppear {
                                        UITextField.appearance().clearButtonMode = .always
                                    }
                                    .focused($isKeyboardFocused)
                            } else {
                                HStack {
                                    Text(dogName)
                                        .frame(height: 24)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                }
                            }
                        }
                        .frame(height: 48)
                    })
                    
                    
                    // 견종
                    VStack(alignment: .leading, content: {
                        Text("견종")
                        
                        HStack {
                            Button {
                                dogSize = .small
                                dogBreed = ""
                                dogBreedIndex = -1
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .fill(dogSize == .small ? Color.gray : Color("Background1"))
                                        .stroke(Color("Stroke1"), lineWidth: 1)
                                    
                                    HStack {
                                        Image(systemName: "dog")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15, height: 15)
                                            .foregroundStyle(Color.primary)
                                        Text("소형견")
                                            .foregroundStyle(Color.primary)
                                    }
                                }
                                .frame(height: 54)
                            }
                            .frame(maxWidth: .infinity)
                            
                            Button {
                                dogSize = .medium
                                dogBreed = ""
                                dogBreedIndex = -1
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .fill(dogSize == .medium ? Color.gray : Color("Background1"))
                                        .stroke(Color("Stroke1"), lineWidth: 1)
                                    
                                    HStack {
                                        Image(systemName: "dog")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .foregroundStyle(Color.primary)
                                        Text("중형견")
                                            .foregroundStyle(Color.primary)
                                    }
                                }
                                .frame(height: 54)
                            }
                            .frame(maxWidth: .infinity)
                            
                            Button {
                                dogSize = .large
                                dogBreed = ""
                                dogBreedIndex = -1
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .fill(dogSize == .large ? Color.gray : Color("Background1"))
                                        .stroke(Color("Stroke1"), lineWidth: 1)
                                    
                                    HStack {
                                        Image(systemName: "dog")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25)
                                            .foregroundStyle(Color.primary)
                                        Text("대형견")
                                            .foregroundStyle(Color.primary)
                                    }
                                }
                                .frame(height: 54)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 3)
                        
                        GroupBox {
                            if isEditing {
                                HStack {
                                    if dogSize == .small {
                                        Menu {
                                            Section("소형견 중 견종을 선택하세요") {
                                                ForEach(Array(dogBreedData.small.enumerated()), id: \.offset) { index, dog in
                                                    Button("\(dog.name)") {
                                                        dogSize = .small
                                                        dogBreedIndex = index
                                                        dogBreed = dogBreedData.small[index].name
                                                    }
                                                }
                                            }
                                            
                                            Section("목록에 없다면 선택하세요") {
                                                Button("여기에 없는 소형견이에요") {
                                                    dogSize = .small
                                                    dogBreedIndex = -999
                                                    dogBreed = ""
                                                }
                                            }
                                            
                                        } label: {
                                            Text(dogBreedIndex == -999 ? "소형견" : dogBreedIndex == -1 ? "선택하세요" : dogBreed)
                                        }
                                        .frame(height: 24)
                                        
                                        Spacer()
                                        
                                    } else if dogSize == .medium {
                                        Menu {
                                            Section("중형견 중 견종을 선택하세요") {
                                                ForEach(Array(dogBreedData.medium.enumerated()), id: \.offset) { index, dog in
                                                    Button("\(dog.name)") {
                                                        dogSize = .medium
                                                        dogBreedIndex = index
                                                        dogBreed = dogBreedData.medium[index].name
                                                    }
                                                }
                                            }
                                            
                                            Section("목록에 없다면 선택하세요") {
                                                Button("여기에 없는 중형견이에요") {
                                                    dogSize = .medium
                                                    dogBreedIndex = -999
                                                    dogBreed = ""
                                                }
                                            }
                                            
                                        } label: {
                                            Text(dogBreedIndex == -999 ? "중형견" : dogBreedIndex == -1 ? "선택하세요" : dogBreed)
                                        }
                                        .frame(height: 24)
                                        
                                        Spacer()
                                        
                                    } else {
                                        Menu {
                                            Section("대형견 중 견종을 선택하세요") {
                                                ForEach(Array(dogBreedData.large.enumerated()), id: \.offset) { index, dog in
                                                    Button("\(dog.name)") {
                                                        dogSize = .large
                                                        dogBreedIndex = index
                                                        dogBreed = dogBreedData.large[index].name
                                                    }
                                                }
                                            }
                                            
                                            Section("목록에 없다면 선택하세요") {
                                                Button("여기에 없는 대형견이에요") {
                                                    dogSize = .large
                                                    dogBreedIndex = -999
                                                    dogBreed = ""
                                                }
                                            }
                                            
                                        } label: {
                                            Text(dogBreedIndex == -999 ? "대형견" : dogBreedIndex == -1 ? "선택하세요" : dogBreed)
                                        }
                                        .frame(height: 24)
                                        
                                        Spacer()
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            } else {
                                HStack {
                                    Text(dogBreed)
                                        .frame(height: 24)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                }
                            }
                        }
                        .frame(height: 48)
                    })
                    
                    // 견종 직접 입력
                    if dogBreedIndex == -999 {
                        VStack(alignment: .leading, content: {
                            Text("견종을 직접 입력해주세요")
                            
                            GroupBox {
                                if isEditing {
                                    TextField("견종을 직접 입력해주세요", text: $dogBreed)
                                        .frame(height: 24)
                                        .foregroundColor(.primary)
                                        .onAppear {
                                            UITextField.appearance().clearButtonMode = .always
                                        }
                                        .focused($isKeyboardFocused)
                                        .submitLabel(.next)
                                        .focused($isFocused, equals: 1)
                                        .onSubmit {
                                            isFocused = 2
                                        }
                                } else {
                                    HStack {
                                        Text(dogBreed)
                                            .frame(height: 24)
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                    }
                                }
                            }
                            .frame(height: 48)
                        })
                    }
                    
                    // 몸무게
                    VStack(alignment: .leading, content: {
                        Text("몸무게 (kg)")
                        
                        GroupBox {
                            if isEditing {
                                TextField("강아지 몸무게를 입력해주세요", text: $dogWeight)
                                    .frame(height: 24)
                                    .keyboardType(.decimalPad)
                                    .foregroundColor(.primary)
                                    .onAppear {
                                        UITextField.appearance().clearButtonMode = .always
                                    }
                                    .submitLabel(.done)
                                    .focused($isKeyboardFocused)
                                    .focused($isFocused, equals: 2)
                            } else {
                                HStack {
                                    Text("\(dogWeight)kg")
                                        .frame(height: 24)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                }
                            }
                        }
                        .frame(height: 48)
                    })
                    
                    // 생일
                    /* VStack(alignment: .leading, content: {
                        Text("생일")
                        
                        GroupBox {
                            if isEditing {
                                DatePicker(selection: $dog_birthday, in: ...Date(), displayedComponents: .date) {
                                    Text("생일을 입력해주세요")
                                }
                                .frame(height: 24)
                                .padding(0)
                            } else {
                                HStack {
                                    Text(dog_birthday, style:. date)
                                        .frame(height: 24)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                }
                            }
                        }
                        .frame(height: 48)
                    })*/
                }) // End of VStack
                .animation(.easeInOut, value: 0.1)
                
                Spacer()
                Spacer().frame(height: 30)
                
                if isKeyboardFocused {
                    CloseKeyboardButton()
                }
                
                Text("프로필 정보는 기기에만 저장되어 앱 제거 시 함께 삭제됩니다")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 10)
                
                if isFirstRegister {
                    // 등록 버튼
                    Button {
                        if (dogName == "" || dogBreed == "" || dogWeight == "") {
                            print("모든 정보를 올바르게 입력해주세요")
                            isAlertShowing = true
                        } else {
                            let doubleWeight = Double(dogWeight)
                            
                            if doubleWeight == nil || doubleWeight! <= 0 {
                                isAlertShowing = true
                            } else {
                                // 프로필 저장
                                let doubleWeight = Double(dogWeight)
                                
                                if doubleWeight == nil || doubleWeight! <= 0 {
                                    isAlertShowing = true
                                } else {
                                    // 프로필 저장
                                    
                                    // 비어 있다면 추가
                                    if profileViewModel.dogProfile.isEmpty {
                                        profileViewModel.addProfile(dogName: dogName, dogBreed: dogBreed, dogSize: dogSize, dogWeight: doubleWeight!, profileImage: selectedImage)
                                    }
                                    // 비어 있지 않다면 업데이트
                                    else {
                                        profileViewModel.updateProfile(index: currentProfileIndex, dogName: dogName, dogBreed: dogBreed, dogSize: dogSize, dogWeight: doubleWeight!, profileImage: selectedImage)
                                    }
                                    
                                    withAnimation(.easeInOut) {
                                        self.isPresented = false
                                    }
                                    
                                    GATracking.sendLogEvent(eventName: GATracking.RegisterStepsMessage.WELCOME_PROFILE_PAGE_REGISTERED, params: nil)
                                    
                                    let params = [
                                        "breed" : dogBreed,
                                        "size" : "\(dogSize.rawValue)",
                                        "weight" : dogWeight
                                    ]
                                    GATracking.sendLogEvent(eventName: GATracking.RegisterStepsMessage.PROFILE_FIRST_REGISTERED_INFO, params: params)
                                    
                                    if selectedImage != nil {
                                        GATracking.sendLogEvent(eventName: GATracking.RegisterStepsMessage.PROFILE_FIRST_IS_IMAGE_REGISTERED, params: nil)
                                    }
                                }
                            }
                        }
                    } label: {
                        Text((dogName == "" || dogBreed == "" || dogWeight == "") ? "모두 입력해주세요" : "완료헀어요")
                            .standardButtonText()
                    }
                    .standardButton()
                    .disabled(dogName == "" || dogBreed == "" || dogWeight == "")
                    
                    // 나중에 등록 버튼
                    Button {
                        isAlert1Presented = true
                    } label: {
                        Text("나중에 등록할래요")
                            .standardButtonText()
                    }
                    .standardButton(backgroundColor: .gray)
                    
                    // 프로필 등록 패스 모달
                    .alert("프로필 등록없이 시작할까요?", isPresented: $isAlert1Presented, actions: {
                        Button("프로필 등록하기", role: nil) {
                            // alert 닫음
                        }
                        Button("나중에 등록할래요", role: nil) {
                            isAlert2Presented = true
                            GATracking.sendLogEvent(eventName: GATracking.RegisterStepsMessage.WELCOME_PROFILE_PASS, params: nil)
                        }
                    }, message: {
                        Text("프로필을 등록하면 우리 아이의 맞춤형 미용 가격을 바로 확인할 수 있어요.")
                    })
                    
                    // 프로필 등록 안내 모달
                    .alert("프로필 등록", isPresented: $isAlert2Presented, actions: {
                        Button("알겠어요") {
                            self.isPresented = false
                        }
                    }, message: {
                        Text("프로필 등록은 언제든지 앱 내 프로필 페이지에서 가능해요")
                    })
                    
                    // 모든 정보 올바르게 입력 경고 모달
                    .alert("모든 정보를 올바르게 입력해주세요", isPresented: $isAlertShowing) {
                        
                    }
                }
            }
        }
        .onAppear() {
            loadProfileData()
            
        } // End of VStack
    }
    
    private func loadProfileData() {
        if !profileViewModel.dogProfile.isEmpty {
            dogName = profileViewModel.dogProfile[currentProfileIndex].dogName
            dogSize = profileViewModel.dogProfile[currentProfileIndex].dogSize
            dogBreed = profileViewModel.dogProfile[currentProfileIndex].dogBreed
            dogWeight = "\(profileViewModel.dogProfile[currentProfileIndex].dogWeight)"
            
            if let profileImageData = profileViewModel.dogProfile[currentProfileIndex].profileImageData {
                if let imageData = profileImageData.decodeToImage() {
                    selectedImage = imageData
                } else {
                    selectedImage = nil
                }
            } else {
                selectedImage = nil
            }
            isEditing = false
        } else {
            isEditing = true
        }
    }
}

#Preview {
    @ObservedObject var profileViewModel = ProfileViewModel()
    @ObservedObject var mapViewModel = MapViewModel()
    
    return Group {
        ProfileView(isPresented: .constant(true), isEditing: false, isFirstRegister: false, profileViewModel: profileViewModel, mapViewModel: mapViewModel)
            .padding()
    }
}

#Preview {
    @ObservedObject var profileViewModel = ProfileViewModel()
    @ObservedObject var mapViewModel = MapViewModel()
    
    return Group {
        ProfileView(isPresented: .constant(true), isEditing: true, isFirstRegister: true, profileViewModel: profileViewModel, mapViewModel: mapViewModel)
            .padding()
    }
}
