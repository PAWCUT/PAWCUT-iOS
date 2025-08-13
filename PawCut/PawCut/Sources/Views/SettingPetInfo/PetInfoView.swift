//
//  PetInfoView.swift
//  PawCut
//
//  Created by donghee on 8/13/25.
//

import SwiftUI

struct PetInfoView: View {
    var body: some View {
        HStack(){
            VStack(alignment: .leading){
                PawTitleLabel
                    .bold24(
                        "반려동물의\n정보를 입력해주세요.",
                        alignment: .leading,
                        lineLimit:2
                    )
                    .padding(.bottom,44)
                PawTitleLabel
                    .semi14(
                        "이름",
                        color:.grayScale02,
                        alignment: .leading,
                        lineLimit: 2
                    )
                //Text 입력칸
                PawTextField("이름을 입력해 주세요.", text:.constant(""), isError:.constant(false))
                    .padding(.bottom,28)
                PawTitleLabel
                    .semi14(
                        "종류",
                        color:.grayScale02,
                        alignment: .leading,
                        lineLimit: 2
                    )
                HStack(spacing:12){
                    PawChoiceButton("강아지", isEnabled: false, horizontalPadding: 0) {
                        
                    }
                    PawChoiceButton("고양이", isEnabled: false, horizontalPadding: 0) {
                        
                    }
                }
            }
        }
        .padding(.horizontal,20)
        PawSecondaryButton("시작하기"){

        }
    }
}

#Preview {
    PetInfoView()
}
