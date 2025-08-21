//
//  PawcutTip.swift
//  PawCut
//
//  Created by 광로 on 7/17/25.
//

import SwiftUI

struct PawcutTipView: View {
    @StateObject private var viewModel = PawcutTipViewModel()
    
    let tips: [(icon: String, text: String)] = [
        ("tip_camera", "'촬영하기'를 누르면 바로 촬영이 시작돼요."),
        ("tip_clock", "6초 타이머가 자동으로 작동해요."),
        ("tip_picture", "사진은 기본으로 8장이 연속 촬영돼요."),
        ("tip_hand", "설정에서 카메라 접근을 먼저 허용해 주세요."),
        ("tip_arrow", "뒤로가기 버튼으로 촬영을 중단할 수 있어요."),
        ("Camera_Sound", "음성을 통해 강아지의 시선을 ~~~~")
    ]
    
    var body: some View {
        ZStack {
            Color.grayScale06
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                PawBackButtonNavigationBar {
                    viewModel.tapBackButton()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    PawTitleLabel("촬영 전에 확인해주세요!", style: .bold24, color: .grayScale01)
                        .padding(.top, 56)
                        .padding(.leading, 20)
                    
                    VStack(spacing: 25) {
                        ForEach(tips, id: \.icon) { tip in
                            TipRow(iconName: tip.icon, text: tip.text)
                        }
                    }
                    .padding(.top, 60)
                    .padding(.horizontal, 32)
                }
                
                Spacer()
                
                PawPrimaryButton("촬영하기") {
                    viewModel.tapNextButton()
                }
            }
        }
        .navigationBarBackButtonHidden()
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
                .foregroundColor(.grayScale02)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

#Preview {
    PawcutTipView()
}
