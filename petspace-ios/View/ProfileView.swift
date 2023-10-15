//
//  ProfileView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 10/15/23.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var profileViewModel = ProfileViewModel()
    @State var isEditing: Bool
    @State var isFirstRegister: Bool
    @State var isAlertShowing: Bool = false
    
    @State var dog_name: String = "NAME_EXAMPLE"
    @State var dog_breed: String = "DOB_BREED_EXAMPLE"
    @State var dog_weight: String = "0.0"
    @State var dog_birthday: Date = Date()
    
    var body: some View {
        VStack {
            HStack {
                Text(isFirstRegister ? "프로필 등록" : "프로필")
                    .font(.title)
                    .bold()
                    .padding(.leading, 6)
                
                Spacer()
                
                if isEditing {
                    Button("취소") {
                        isEditing = false
                    }
                    .padding(.trailing, 10)
                }
                
                Button(isEditing ? "저장" : "편집") {
                    if isEditing {
                        isAlertShowing = true
                    }
                    else {
                        isEditing = true
                    }
                }
                .padding(.trailing, 6)
                .alert("모든 정보를 입력해주세요!", isPresented: $isAlertShowing) {
                    
                }
            }
            .padding()
            
            ScrollView {
                Image("ProfileExample")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .padding(.vertical, 30)
                
                VStack(spacing: 20, content: {
                    
                    // 이름
                    VStack(alignment: .leading, content: {
                        Text("이름")
                        
                        GroupBox {
                            if isEditing {
                                TextField("이름을 입력해주세요", text: $dog_name)
                                    .frame(height: 24)
                                    .foregroundColor(.primary)
                                    .onAppear {
                                        UITextField.appearance().clearButtonMode = .always
                                    }
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
                                        Menu {
                                            Button("여기에 없는 소형견이에요") {
                                                
                                            }
                                        } label: {
                                            Text("소형견")
                                        }
                                        Menu {
                                            Button("여기에 없는 중형견이에요") {
                                                
                                            }
                                        } label: {
                                            Text("중형견")
                                        }
                                        Menu {
                                            Button("여기에 없는 대형견이에요") {
                                                
                                            }
                                        } label: {
                                            Text("대형견")
                                        }
                                    } label: {
                                        Text("선택하세요")
                                    }
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
                    
                    // 몸무게
                    VStack(alignment: .leading, content: {
                        Text("몸무게")
                        
                        GroupBox {
                            if isEditing {
                                TextField("몸무게를 입력해주세요", text: $dog_weight)
                                    .frame(height: 24)
                                    .keyboardType(.decimalPad)
                                    .foregroundColor(.primary)
                                    .onAppear {
                                        UITextField.appearance().clearButtonMode = .always
                                    }
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
                    VStack(alignment: .leading, content: {
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
                    })
                })
                
                Text("프로필 정보는 기기에만 저장되어 앱 제거 시 함께 삭제됩니다")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 24)
            }
            .padding()
        }
        
    }
}

#Preview {
    ProfileView(isEditing: false, isFirstRegister: false)
}
