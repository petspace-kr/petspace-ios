//
//  ProfileView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/7/23.
//

import SwiftUI

struct ProfileView: View {
    
    @FocusState private var isKeyboardFocused: Bool
    
    @State var isEditing: Bool
    @State var isFirstEditing: Bool = false
    @State var isFirstRegister: Bool
    @Binding var isPresented: Bool
    
    @State var isAlertShowing: Bool = false
    @State var isAlert1Presented: Bool = false
    @State var isAlert2Presented: Bool = false
    
    @State var dog_name: String = ""
    @State var dog_weight: String = ""
    
    @State var dog_size: Int = -1
    @State var dog_breed_index: Int = -1
    @State var dog_breed: String = ""
    
    let dog_size_text: [String] = ["소형견", "중형견", "대형견"]
    
    @State private var selectedImage: UIImage?
    @State private var showImagePicker: Bool = false
    
    @Binding var isRedraw: Bool
    
    @FocusState private var isFocused: Int?
    
    var body: some View {
        VStack {
            HStack {
                Text(isFirstRegister ? "프로필을 등록해주세요" : (isEditing ? "프로필 수정" : "프로필"))
                    .font(.title)
                    .bold()
                    .padding(.leading, 6)
                    // .animation(.easeInOut(duration: 0.2))
                    .animation(.easeInOut, value: 0.2)
                
                Spacer()
                
                if isEditing && !isFirstRegister {
                    Button("취소") {
                        isEditing = false
                        initProfileData()
                    }
                    .padding(.trailing, 10)
                    .disabled(isFirstEditing)
                }
                
                if !isFirstRegister {
                    Button(isEditing ? "저장" : "편집") {
                        if isEditing {
                            if (dog_name == "" || dog_breed == "" || dog_weight == "") {
                                isAlertShowing = true
                            }
                            else {
                                let doubleWeight = Double(dog_weight)
                                
                                if doubleWeight == nil || doubleWeight! <= 0 {
                                    isAlertShowing = true
                                } else {
                                    UserDefaults.standard.set(dog_name, forKey: "profile_dog_name")
                                    UserDefaults.standard.set(dog_size, forKey: "profile_dog_size")
                                    UserDefaults.standard.set(dog_breed, forKey: "profile_dog_breed")
                                    UserDefaults.standard.set(dog_weight, forKey: "profile_dog_weight")
                                    
                                    if let image = selectedImage {
                                        if let jpegData = image.jpegData(compressionQuality: 1.0) {
                                            UserDefaults.standard.set(jpegData, forKey: "profile_image")
                                        }
                                    } else {
                                        UserDefaults.standard.removeObject(forKey: "profile_image")
                                    }
                                    
                                    isEditing = false
                                }
                            }
                        }
                        else {
                            isEditing = true
                        }
                        // self.isRedraw.toggle()
                    }
                    .padding(.trailing, 6)
                    .alert("모든 정보를 올바르게 입력해주세요", isPresented: $isAlertShowing) {
                        
                    }
                }
                
            }
            .padding()
            
            // ScrollView {
            VStack {
                /* ZStack {
                    Image("ProfileExample")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 175, height: 175)
                        .clipShape(Circle())
                        .padding(.vertical, 30)
                } */
                
//                if let image = selectedImage {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 100, height: 100)
//                        .clipShape(Circle())
//                }
//
//                Button("이미지 선택") {
//                    selectImage()
//                }
                
//                    ScrollView {
//
//                    } // End of ScrollView
                // .animation(.easeInOut(duration: 0.1))
                // .animation(.easeInOut, value: 0.1)
                
                VStack(spacing: 20, content: {
                    
                    // 고양이 강아지
//                        GeometryReader { geometry in
//                            HStack(alignment: .center) {
//                                Button {
//
//                                } label: {
//                                    Label("강아지", systemImage: "dog")
//                                        .tint(.blue)
//                                }
//                                .frame(width: geometry.size.width / 2 - 10)
//                                .background(.blue)
//
//                                Button {
//
//                                } label: {
//                                    Label("고양이", systemImage: "cat")
//                                        .tint(.blue)
//                                }
//                                .frame(width: geometry.size.width / 2 - 10)
//                                .background(.blue)
//                            }
//                        }
                    
                    if isEditing {
                        ZStack {
                            Circle()
                                .fill(Color("SecondaryBackground"))
                                .frame(width: 150, height: 150)
                            
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
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
                                TextField("강아지 이름을 입력해주세요", text: $dog_name)
                                    .frame(height: 24)
                                    .foregroundColor(.primary)
                                    .onAppear {
                                        UITextField.appearance().clearButtonMode = .always
                                    }
                                    .focused($isKeyboardFocused)
                            } else {
                                HStack {
                                    Text(dog_name)
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
                                                    ForEach(Array(dogBreeds.small.enumerated()), id: \.offset) { index, dog in
                                                        Button("\(dog.name)") {
                                                            dog_size = 0
                                                            dog_breed_index = index
                                                            dog_breed = dogBreeds.small[index].name
                                                        }
                                                    }
                                                }
                                                
                                                Section("목록에 없다면 선택하세요") {
                                                    Button("여기에 없는 소형견이에요") {
                                                        dog_size = 0
                                                        dog_breed_index = -999
                                                        dog_breed = ""
                                                    }
                                                }
                                                
                                            } label: {
                                                Text("소형견")
                                            }
                                            Menu {
                                                Section("중형견 중 견종을 선택하세요") {
                                                    ForEach(Array(dogBreeds.medium.enumerated()), id: \.offset) { index, dog in
                                                        Button("\(dog.name)") {
                                                            dog_size = 1
                                                            dog_breed_index = index
                                                            dog_breed = dogBreeds.medium[index].name
                                                        }
                                                    }
                                                }
                                                
                                                Section("목록에 없다면 선택하세요") {
                                                    Button("여기에 없는 중형견이에요") {
                                                        dog_size = 1
                                                        dog_breed_index = -999
                                                        dog_breed = ""
                                                    }
                                                }
                                                
                                            } label: {
                                                Text("중형견")
                                            }
                                            Menu {
                                                Section("대형견 중 견종을 선택하세요") {
                                                    ForEach(Array(dogBreeds.large.enumerated()), id: \.offset) { index, dog in
                                                        Button("\(dog.name)") {
                                                            dog_size = 2
                                                            dog_breed_index = index
                                                            dog_breed = dogBreeds.large[index].name
                                                        }
                                                    }
                                                }
                                                
                                                Section("목록에 없다면 선택하세요") {
                                                    Button("여기에 없는 대형견이에요") {
                                                        dog_size = 2
                                                        dog_breed_index = -999
                                                        dog_breed = ""
                                                    }
                                                }
                                                
                                            } label: {
                                                Text("대형견")
                                            }
                                        }
                                        
                                    } label: {
                                        // Text(dog_breed == "" ? "선택하세요" : (dog_breed_index == -999 ? dog_size_text[dog_size] : dog_breed))
                                        
                                        Text(dog_breed_index == -999 ? dog_size_text[dog_size] : (dog_breed == "" ? "선택하세요" : dog_breed))
                                    } // End of Menu
                                    .frame(height: 24)
                                    Spacer()
                                }
                            } else {
                                HStack {
                                    Text(dog_breed)
                                        .frame(height: 24)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                }
                            }
                        }
                        .frame(height: 48)
                    })
                    
                    // 견종 직접 입력
                    if dog_breed_index == -999 {
                        VStack(alignment: .leading, content: {
                            Text("견종을 직접 입력해주세요")
                            
                            GroupBox {
                                if isEditing {
                                    TextField("견종을 직접 입력해주세요", text: $dog_breed)
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
                                        Text(dog_breed)
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
                                TextField("강아지 몸무게를 입력해주세요", text: $dog_weight)
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
                                    Text("\(dog_weight)kg")
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
                    Button("완료했어요") {
                        if (dog_name == "" || dog_breed == "" || dog_weight == "") {
                            print("모든 정보를 올바르게 입력해주세요")
                            isAlertShowing = true
                        } else {
                            let doubleWeight = Double(dog_weight)
                            
                            if doubleWeight == nil || doubleWeight! <= 0 {
                                isAlertShowing = true
                            } else {
                                UserDefaults.standard.set(dog_name, forKey: "profile_dog_name")
                                UserDefaults.standard.set(dog_size, forKey: "profile_dog_size")
                                UserDefaults.standard.set(dog_breed, forKey: "profile_dog_breed")
                                UserDefaults.standard.set(dog_weight, forKey: "profile_dog_weight")
                                
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
                                ServerLogger.sendLog(group: "TEST_LOG", message: "PROFILE_FIRST_REGISTERED_INFO_size:\(dog_size)_breed:\(dog_breed)_weight:\(dog_weight)kg")
                            }
                        }
                    }
                    .bigButton()
                    // .disabled(dog_name == "" || dog_breed == "" || Double(dog_weight)! <= 0)
                    
                    Button("나중에 등록할래요") {
                        isAlert1Presented = true
                    }
                    .bigButton(backgroundColor: .gray)
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
            .padding()
        }
        .onAppear() {
            initProfileData()
            
            staticMapViewModel.fireTimer()
            
        } // End of VStack
        .onDisappear() {
            staticMapViewModel.startTimer()
        }
    }
    
    func initProfileData() {
        dog_name =  UserDefaults.standard.string(forKey: "profile_dog_name") ?? ""
        dog_size = UserDefaults.standard.integer(forKey: "profile_dog_size")
        dog_breed = UserDefaults.standard.string(forKey: "profile_dog_breed") ?? ""
        dog_weight = UserDefaults.standard.string(forKey: "profile_dog_weight") ?? ""
        
        if let data = UserDefaults.standard.data(forKey: "profile_image") {
            selectedImage = UIImage(data: data)
        } else {
            selectedImage = nil
        }
        
        if dog_size <= 0 {
            dog_size = -1
        }
        
        // 처음 등록한다면 바로 수정 모드로 들어감
        if !isFirstRegister && dog_name == "" && dog_breed == "" && dog_weight == "" {
            isFirstEditing = true
            isEditing = true
        }
    }
    
//    func selectImage() {
//        let imagePicker = UIImagePickerController()
//        imagePicker.sourceType = .photoLibrary
//        UIApplication.shared.windows.first?.rootViewController?.present(imagePicker, animated: true)
//    }
//
//    func saveImageToUserDefaults(image: UIImage?) {
//        if let imageData = image?.jpegData(compressionQuality: 1.0) {
//            UserDefaults.standard.set(imageData, forKey: "UserProfileImage")
//        }
//    }
}

#Preview {
    ProfileView(isEditing: false, isFirstRegister: false, isPresented: .constant(true), isRedraw: .constant(false))
}

#Preview {
    ProfileView(isEditing: true, isFirstRegister: true, isPresented: .constant(true), isRedraw: .constant(false))
}
