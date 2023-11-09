//
//  BetaInfoView.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import SwiftUI

struct BetaInfoView: View {
    
    // Environment
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("펫스페이스는 현재\n베타 서비스 중이에요")
                    .font(.title)
                    .bold()
                
                Spacer()
            }
            
            Spacer()
                .frame(height: 10)
            
            HStack {
                Text("아래 내용을 읽고 확인해주세요")
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
            Spacer()
                .frame(height: 30)
            
            ScrollView {
                VStack(spacing: 16) {
                    GroupBox {
                        HStack(alignment: .top, spacing: 14) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.red)
                                    .frame(width: 52, height: 52)
                                    .cornerRadius(10)
                                
                                Image(systemName: "mappin.and.ellipse")
                                    .resizable()
                                    .scaledToFit()
                                    .bold()
                                    .frame(width: 24)
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("강남구 지역 정보만 제공하고 있어요")
                                    .bold()
                                    .font(.system(size: 15))
                                
                                Text("펫스페이스에서는 현재 강남구 지역 내 00개 애견미용실 정보를 제공하고 있어요. 타 지역 매장 정보는 지속해서 업데이트 중이니 기대해주세요. 빠른 시일 내에 전국 정보를 제공할 예정이에요.")
                                    .font(.system(size: 12))
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 1)
                            }
                            
                            Spacer()
                        }
                    } // End of GroupBox
                    
                    GroupBox {
                        HStack(alignment: .top, spacing: 14) {
                            ZStack(alignment: .center) {
                                Rectangle()
                                    .foregroundColor(.orange)
                                    .frame(width: 52, height: 52)
                                    .cornerRadius(10)
                                
                                Image(systemName: "calendar.badge.clock")
                                    .resizable()
                                    .scaledToFit()
                                    .bold()
                                    .frame(width: 24)
                                    .foregroundColor(.white)
                                
                                .padding(.top, 3)
                                .padding(.leading, 3)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("온라인 예약 서비스를 제공 예정이에요")
                                    .bold()
                                    .font(.system(size: 15))
                                
                                Text("펫스페이스에서는 조회 가능한 모든 애견미용실에 대한 온라인 예약 서비스를 제공할 예정이에요. 현재 각 매장과 조율 중에 있으며 빠른 시일 내 서비스를 제공할게요.")
                                    .font(.system(size: 12))
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 1)
                            }
                            
                            Spacer()
                        }
                    } // End of GroupBox
                    
                    GroupBox {
                        HStack(alignment: .top, spacing: 14) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.gray)
                                    .frame(width: 52, height: 52)
                                    .cornerRadius(10)
                                
                                Image(systemName: "square.stack.3d.up.trianglebadge.exclamationmark.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .bold()
                                    .frame(width: 24)
                                    .foregroundColor(.white)
                                    .padding(.top, 3)
                                    .padding(.leading, 3)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("사소한 기능 오류가 발생할 수 있어요")
                                    .bold()
                                    .font(.system(size: 15))
                                
                                Text("베타 서비스 중 사소한 기능 오류가 발생할 수 있어요. 저희 팀에서는 지속적으로 오류 해결을 위해 노력하고 있으니 사용 중 불편함이 있더라도 너그러이 양해 부탁드려요.")
                                    .font(.system(size: 12))
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 1)
                            }
                            
                            Spacer()
                        }
                    } // End of GroupBox
                }
            }
            
            Spacer()
            
            Text("기능 오류 신고는 앱 내 피드백 페이지에서 가능해요\n사소한 오류 신고는 언제든지 환영하며, 앱 기능 개선에 큰 도움이 돼요")
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.bottom, 10)
            
            Button {
                // self.isPresented = false
                dismiss() 
            } label: {
                Text("완료했어요")
                    .standardButtonText()
            }
            .standardButton()
        }
    }
}

#Preview {
    BetaInfoView(isPresented: .constant(true))
        .padding()
}
