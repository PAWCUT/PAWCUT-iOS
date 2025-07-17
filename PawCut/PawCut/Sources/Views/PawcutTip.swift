//
//  PawcutTip.swift
//  PawCut
//
//  Created by 광로 on 7/17/25.
//

import SwiftUI

struct PawcutTip: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("GrayScale06Color")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // 상단바
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color("GrayScale01Color"))
                        }
                        .frame(width: 33, height: 44)
                        
                        Spacer()
                        
                        
                    }
                    .padding(.top, 8)
                    
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            // 타이틀
                            HStack {
                                Text("촬영 전에 확인해주세요!")
                                    .pretendardFont(size: ._24, weight: .bold)
                                    .foregroundColor(Color("GrayScale01Color"))
                                    .padding(.top, 56)
                                    .padding(.leading, 20)
                                
                                Spacer()
                            }
                            
                            // Tips 리스트
                            VStack(spacing: 25) {
                                
                                TipRow(
                                    iconName: "tip_camera",
                                    text: "'촬영하기'를 누르면 바로 촬영이 시작돼요."
                                )
                                
                                
                                TipRow(
                                    iconName: "tip_clock",
                                    text: "6초 타이머가 자동으로 작동해요."
                                )
                                
                                
                                TipRow(
                                    iconName: "tip_picture",
                                    text: "사진은 기본으로 8장이 연속 촬영돼요."
                                )
                                
                                
                                TipRow(
                                    iconName: "tip_hand",
                                    text: "설정에서 카메라 접근을 먼저 허용해 주세요."
                                )
                                
                                
                                TipRow(
                                    iconName: "tip_arrow",
                                    text: "뒤로가기 버튼으로 촬영을 중단할 수 있어요."
                                )
                                
                                
                                TipRow(
                                    iconName: "camera_sound",
                                    text: "음성을 통해 강아지의 시선을 ~~~~"
                                )
                            }
                            .padding(.top, 60)
                            .padding(.horizontal, 32)
                            
                            
                        }
                    }
                    
                    // 버튼
                    VStack(spacing: 0) {
                        NavigationLink(destination: PawcutReady()) {
                            Text("촬영하기")
                                .pretendardFont(size: ._16, weight: .semibold)
                                .foregroundColor(Color("GrayScale06Color"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 59)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color("PointPurple01Color"))
                                )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    .background(Color("GrayScale06Color"))
                }
            }
            
        }
        
    }
}

struct TipRow: View {
    let iconName: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
            
            Text(text)
                .pretendardFont(size: ._16, weight: .semibold)
                .foregroundColor(Color("GrayScale02Color"))
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

#Preview {
    PawcutTip()
}
