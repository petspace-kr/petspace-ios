//
//  ProfileAddView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 12/5/23.
//

import SwiftUI

struct ProfileAddView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    
    @ObservedObject var profileViewModel: ProfileViewModel
    
    // 이미지 선택 관련 변수
    @State private var selectedImage: UIImage?
    @State private var showImagePicker: Bool = false
    
    // Text Field 편집용 변수
    @State private var dogName: String = ""
    @State private var dogBreed: String = ""
    @State private var dogSize: DogSize = .small
    @State private var dogWeight: String = ""
    @State private var dogBreedIndex: Int = -1
    
    // Model
    @State private var isInfoModalShowing: Bool = false
    
    // 키보드 Focus 상태 변수
    @FocusState private var isKeyboardFocused: Bool
    @FocusState private var isFocused: Int?
    
    // 견종
    @State private var dogBreedData: DogBreed = load("dogbreed.json")
    private let dogSizeString: [String] = ["소형견", "중형견", "대형견"]
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                Text("프로필 사진")
                    .font(.headline)
                    .bold()
                
                HStack {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(Color("Background2"))
                            .frame(width: 100, height: 100)
                        
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
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
                    
                    Spacer()
                }
                
                Spacer()
                    .frame(height: 20)
                
                // 이름
                Text("이름")
                    .font(.headline)
                    .bold()
                
                GroupBox {
                    TextField("강아지 이름을 입력해주세요", text: $dogName)
                        .frame(height: 24)
                        .foregroundColor(.primary)
                        .onAppear {
                            UITextField.appearance().clearButtonMode = .always
                        }
                        .focused($isKeyboardFocused)
                }
                .frame(height: 48)
                
                Spacer()
                    .frame(height: 20)
                
                // 견종
                HStack {
                    Text("견종")
                        .font(.headline)
                        .bold()
                    
                    Spacer()
                    
                    Button {
                        isInfoModalShowing = true
                    } label: {
                        Label("", systemImage: "info.circle")
                            .foregroundColor(.gray)
                    }
                }
                
                // 크기 선택 버튼
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
                                    .foregroundStyle(dogSize == .small ? Color.white : Color.primary)
                                Text("소형견")
                                    .foregroundStyle(dogSize == .small ? Color.white : Color.primary)
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
                                    .foregroundStyle(dogSize == .medium ? Color.white : Color.primary)
                                Text("중형견")
                                    .foregroundStyle(dogSize == .medium ? Color.white : Color.primary)
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
                                    .foregroundStyle(dogSize == .large ? Color.white : Color.primary)
                                Text("대형견")
                                    .foregroundStyle(dogSize == .large ? Color.white : Color.primary)
                            }
                        }
                        .frame(height: 54)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 3)
                
                // 견종 선택 메뉴
                GroupBox {
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
                }
                
                // 견종 직접 입력
                if dogBreedIndex == -999 {
                    VStack(alignment: .leading, content: {
                        GroupBox {
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
                        }
                        .frame(height: 48)
                    })
                    .padding(.top, 6)
                }
                
                Spacer()
                    .frame(height: 20)
                
                // 몸무게
                Text("몸무게 (kg)")
                    .font(.headline)
                    .bold()
                
                GroupBox {
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
                }
                .frame(height: 48)
                
                Spacer()
                    .frame(height: 10)
                
                HStack {
                    Text("프로필 정보는 기기에만 저장되어 앱 제거 시 함께 삭제됩니다")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 10)
                }.frame(maxWidth: .infinity)
                
                
                Spacer()
                
                /* if isKeyboardFocused {
                    HStack {
                        CloseKeyboardButton()
                    }
                    .frame(maxWidth: .infinity)
                }*/
                
                Spacer()
                    .frame(height: 10)
            }
            .padding()
            .navigationTitle("프로필 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        dismiss()
                        isPresented = false
                    } label: {
                        Text("취소")
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Button("저장") {
                            isLoading = true
                            
                            if let dogWeightDouble = Double(dogWeight) {
                                profileViewModel.addProfile(dogName: dogName, dogBreed: dogBreed, dogSize: dogSize, dogWeight: dogWeightDouble, profileImage: selectedImage)
                                
                                dismiss()
                                isPresented = false
                            }
                        }
                        .disabled(dogName == "" || dogBreed == "" || dogWeight == "" || Double(dogWeight) == nil)
                    }
                }
            }
        }
        .onTapGesture(perform: {
            if isKeyboardFocused {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        })
        
        // Image Picker
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        
        // 견종 크기 안내
        .alert("견종의 크기를 구별하는 방법", isPresented: $isInfoModalShowing, actions: {
            Button("알겠어요", role: nil) { }
        }, message: {
            Text("견종의 크기 구분은 국가 및 표준에 따라 달라질 수 있어요. \n일반적으로는 몸무게에 따라 구분해요. \n구분이 명확하지 않다면 아래 기준에 따라 선택해주세요. \n\n소형견: 9kg 이하\n중형견: 9kg에서 23kg\n대형견: 23kg 이상\n(*해당 견종의 성견 기준이에요)")
        })
    }
}

#Preview {
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    return Group {
        ProfileAddView(isPresented: .constant(true), profileViewModel: profileViewModel)
    }
}
