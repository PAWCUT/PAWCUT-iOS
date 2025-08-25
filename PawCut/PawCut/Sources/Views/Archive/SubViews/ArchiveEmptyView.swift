//
//  EmptyArchiveView.swift
//  PawCut
//
//  Created by taeni on 8/12/25.
//

import SwiftUI

struct ArchiveEmptyView: View {

    let petType: PetType
    private let navigationManager = NavigationManager.shared
    
    var body: some View {
        VStack(spacing: 22) {
            Spacer()
            
            ImageComponent(
                imageName: "empty\(petType.fileSuffix)",
                size: CGSize(width: 100, height: 100)
            )
            
            VStack(spacing: 12) {
                PawTitleLabel.semi18("비어있음", color: .grayScale01)
                
                PawBodyLabel.med14(
                    "아직 찍은 사진이 없습니다.\n오늘의 하루를 남겨보세요.",
                    color: .grayScale03,
                    alignment: .center,
                    lineLimit: 2
                )
            }
            
            PawTakeCutButton("포우컷 촬영하러 가기") {
                navigationManager.navigate(to: .main(.camera))
            }
            .padding(.horizontal, 116)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.grayScale06)
    }
}
#Preview {
    ArchiveEmptyView(petType: .dog)
}
