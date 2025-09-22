//
//  EmptyArchiveView.swift
//  PawCut
//
//  Created by taeni on 8/12/25.
//

import SwiftUI

struct ArchiveEmptyView: View {
    let petType: PetType
    let didTapTakeCutButton: () -> Void
    
    var body: some View {
        VStack(spacing: 22) {
            Spacer()
            
            ImageComponent(
                imageName: "empty\(petType.fileSuffix)",
                size: CGSize(width: 100, height: 100)
            )
            
            EmptyContent(
                stateString: "비어있음",
                explainString: "아직 찍은 사진이 없습니다.\n오늘의 하루를 남겨보세요."
            )
            
            PawTakeCutButton("포우컷 촬영하러 가기") {
                didTapTakeCutButton()
            }
            .padding(.horizontal, 116)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.grayScale06)
    }
}
#Preview {
    ArchiveEmptyView(petType: .dog) {
        print("did tap")
    }
}
