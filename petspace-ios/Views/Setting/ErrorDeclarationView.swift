//
//  ErrorDeclarationView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct ErrorDeclarationView: View {
    
    @State var title: String = ""
    @State var content: String = ""
    
    @Binding var isPresent: Bool
    @State var isAlertPresented: Bool = false
    @State var isOkPresented: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("기능 오류 신고하기")
                    .font(.title)
                    .bold()
                
                Spacer()
            }
            
            Spacer()
                .frame(height: 10)
            
            HStack {
                Text("앱 사용 중 발생한 기능 오류뿐 아니라\n앱에 대한 의견 등 모두 편하게 말씀해주세요")
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
            Spacer()
                .frame(height: 30)
            
            VStack(alignment: .leading, content: {
                Text("제목")
                
                TextEditor(text: $title)
                    .frame(height: 64)
                    .foregroundColor(.primary)
                    .border(.gray)
            })
            
            Spacer()
                .frame(height: 20)
            
            VStack(alignment: .leading, content: {
                Text("내용")
                
                TextEditor(text: $content)
                    .frame(height: 300)
                    .foregroundColor(.primary)
                    .border(.gray)
            })
            
            Spacer()
            
            Text("")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .padding(.vertical, 10)
            
            Button("제출하기") {
                
                if title == "" || content == "" {
                    isAlertPresented = true
                } else {
                    let pattern = "[!@#\\$%^&*()\"'/\\\\\\-:?!=]"
                    let newTitle = title.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
                    let newContent = content.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
                    
                    let message: String = "{\"title\": \"\(newTitle)\", \"content\": \"\(newContent)\"}"
                    ServerLogger.sendLog(group: "BETA_USER_MESSAGE_LOG", message: message)
                    
                    isOkPresented = true
                }
            }
            // .bigButton()
            .alert("작성되지 않은 내용이 있어요", isPresented: $isAlertPresented, actions: {
                Button("알겠어요") {
//                    self.isPresent = false
                }
            }, message: {
                Text("제목과 내용을 모두 작성해주세요")
            })
            .alert("제출되었습니다", isPresented: $isOkPresented, actions: {
                Button("알겠어요") {
                    title = ""
                    content = ""
                    self.isPresent = false
                }
            }, message: {
                Text("소중한 의견 감사드립니다. 앱 서비스 발전을 위해 더욱 노력하겠습니다.")
            })
        }
    }
}

#Preview {
    ErrorDeclarationView(isPresent: .constant(true))
        .padding()
}
