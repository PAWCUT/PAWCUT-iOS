//
//  emptyStateView.swift
//  PawCut
//
//  Created by taeni on 8/12/25.
//

import SwiftUI

struct EmptyStateView: View {
    
    let petType: PetType
    
    var body: some View {
        VStack(spacing: 22) {
            Spacer()
            
            ImageComponent(
                imageName: "empty\(petType.fileSuffix)",
                size: CGSize(width: 100, height: 100)
            )
            
            VStack(spacing: 12) {
                PawTitleLabel.semi17("비어있음", color: .grayScale01)
                
                PawBodyLabel.med14(
                    "아직 찍은 사진이 없습니다.\n오늘의 하루를 남겨보세요.",
                    color: .grayScale03,
                    alignment: .center,
                    lineLimit: 2
                )
            }
            
            // TODO: 포우컷 카메라 화면으로 이동
            TakePawCutButton("포우컷 촬영하러 가기") {
            }
            .padding(.horizontal, 116)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.grayScale06)
    }
}
#Preview {
    EmptyStateView(petType: .cat)
}
