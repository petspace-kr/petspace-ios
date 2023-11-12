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
                    }
                    .disabled(isFirstEditing)
                    .padding(.trailing, 6)
                }
                
                if !isFirstRegister {
                    Button(isEditing ? "저장" : "편집") {
                        if isEditing {
                            if (dogName == "" || dogBreed == "" || dogWeight == "") {
                                isAlertShowing = true
                            }
                            else {
                                let doubleWeight = Double(dogWeight)
                                
                                if doubleWeight == nil || doubleWeight! <= 0 {
                                    isAlertShowing = true
                                } else {
                                    // 프로필 저장
                                    
                                    withAnimation(.easeInOut) {
                                        isEditing = false
                                    }
                                    
                                }
                            }
                        }
                        else {
                            withAnimation(.easeInOut) {
                                isEditing = true
                            }
                        }
                    }
                    .alert("모든 정보를 올바르게 입력해주세요", isPresented: $isAlertShowing) {
                        
                    }
                }
                
            }
            
            VStack {
                VStack(spacing: 20, content: {
                    
                     // 고양이 강아지
                        /* GeometryReader { geometry in
                            HStack(alignment: .center) {
                                Button {

                                } label: {
                                    Label("강아지", systemImage: "dog")
                                        .tint(.blue)
                                }
                                .frame(width: geometry.size.width / 2 - 10)
                                .background(.blue)

                                Button {

                                } label: {
                                    Label("고양이", systemImage: "cat")
                                        .tint(.blue)
                                }
                                .frame(width: geometry.size.width / 2 - 10)
                                .background(.blue)
                            }
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
                                    selectedImage = nil
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
                        .padding(.bottom, 10)
                    } else {
                        ZStack {
                            if let image = selectedImage {
                                Circle()
                                    .fill(Color("SecondaryBackground"))
                                    .frame(width: 150, height: 150)
                                
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
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
                        
                        GroupBox {
                            if isEditing {
                                HStack {
                                    Menu {
                                        Section("소, 중, 대형견 중 선택하세요") {
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
                                                Text("소형견")
                                            }
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
                                                Text("중형견")
                                            }
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
                                                Text("대형견")
                                            }
                                        }
                                        
                                    } label: {
                                        // Text(dog_breed == "" ? "선택하세요" : (dog_breed_index == -999 ? dog_size_text[dog_size] : dog_breed))
                                        
                                        // Text(dogBreedIndex == -999 ? DogSize(rawValue: dogSize.rawValue)?.rawValue : (dogBreed == "" ? "선택하세요" : dogBreed))
                                        
                                        Text(dogBreedIndex == -999 ? dogSizeString[dogSize.rawValue] : (dogBreed == "" ? "선택하세요" : dogBreed))
                                        
                                    } // End of Menu
                                    .frame(height: 24)
                                    Spacer()
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
                
                if isKeyboardFocused {
                    CloseKeyboardButton()
                }
                
                Text("프로필 정보는 기기에만 저장되어 앱 제거 시 함께 삭제됩니다")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 10)
                
                if isFirstRegister {
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
                                
                                if let image = selectedImage {
                                    if let jpegData = image.jpegData(compressionQuality: 1.0) {
                                        UserDefaults.standard.set(jpegData, forKey: "profile_image")
                                    }
                                }
                                else {
                                    UserDefaults.standard.removeObject(forKey: "profile_image")
                                }
                        
                                self.isPresented = false
                                
                                ServerLogger.sendLog(group: "TEST_LOG", message: "WELCOME_PROFILE_PAGE_REGISTERED")
                                ServerLogger.sendLog(group: "TEST_LOG", message: "PROFILE_FIRST_REGISTERED_INFO_size:\(dogSize)_breed:\(dogBreed)_weight:\(dogWeight)kg")
                            }
                        }
                    } label: {
                        Text("완료헀어요")
                            .standardButtonText()
                    }
                    .standardButton()
                    
                    // .disabled(dog_name == "" || dog_breed == "" || Double(dog_weight)! <= 0)
                    
                    Button {
                        isAlert1Presented = true
                    } label: {
                        Text("나중에 등록할래요")
                            .standardButtonText()
                    }
                    .standardButton(backgroundColor: .gray)
                    .alert("프로필 등록없이 시작할까요?", isPresented: $isAlert1Presented, actions: {
                        Button("프로필 등록하기", role: nil) {
                            // alert 닫음
                        }
                        Button("나중에 등록할래요", role: nil) {
                            isAlert2Presented = true
                            ServerLogger.sendLog(group: "TEST_LOG", message: "WELCOME_PROFILE_PAGE_PASSED")
                        }
                    }, message: {
                        Text("프로필을 등록하면 우리 아이의 맞춤형 미용 가격을 바로 확인할 수 있어요.")
                    })
                    .alert("프로필 등록", isPresented: $isAlert2Presented, actions: {
                        Button("알겠어요") {
                            self.isPresented = false
                        }
                    }, message: {
                        Text("프로필 등록은 언제든지 앱 내 프로필 페이지에서 가능해요")
                    })
                    .alert("모든 정보를 올바르게 입력해주세요", isPresented: $isAlertShowing) {
                        
                    }
                }
            }
        }
        .onAppear() {
            // initProfileData()
            
            // mapViewModel.fireTimer()
            
        } // End of VStack
        .onDisappear() {
            // mapViewModel.startTimer()
        }
    }
    
    private func loadProfileData() {
        
    }
    
    private func saveProfileData() {
        
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
