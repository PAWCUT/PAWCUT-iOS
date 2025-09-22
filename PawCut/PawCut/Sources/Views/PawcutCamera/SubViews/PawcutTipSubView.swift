//
//  PawcutTipSubView.swift
//  PawCut
//
//  Created by 광로 on 9/21/25.
//

import SwiftUI

struct PawcutTipSubView: View {
    let tips: [TipData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PawTitleLabel.bold24(
                "촬영 전에 확인해주세요!",
                color: .grayScale01
            )
            .padding(.top, 56)
            .padding(.leading, 20)
            .padding(.bottom, 60)
            
            ForEach(Array(tips.enumerated()), id: \.element.iconName) { index, tip in
                HStack(alignment: .top, spacing: 12) {
                    ImageComponent(
                        imageName: tip.iconName,
                        size: CGSize(width: 20, height: 20)
                    )
                    PawBodyLabel.semi16(
                        tip.message,
                        color: .grayScale02,
                        lineLimit: 1
                    )
                }
                .padding(.horizontal, 32)
                .padding(.bottom, index < tips.count - 1 ? 25 : 0)
            }
        }
    }
}

#Preview {
    let sampleTips = [
        TipData(iconName: "ic_tip_camera", message: "'촬영하기'를 누르면 바로 촬영이 시작돼요."),
        TipData(iconName: "ic_tip_clock", message: "6초 타이머가 자동으로 작동해요."),
        TipData(iconName: "ic_tip_picture", message: "사진은 기본으로 8장이 연속 촬영돼요.")
    ]
    ZStack {
        Color.grayScale06
            .ignoresSafeArea()
        
        PawcutTipSubView(tips: sampleTips)
    }
}
