//
//  PetInfoView.swift
//  PawCut
//
//  Created by donghee on 8/13/25.
//

import SwiftUI

struct PetInfoView: View {
    @StateObject private var viewModel = PetInfoViewModel()
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                PawTitleLabel
                    .bold24(
                        "반려동물의\n정보를 입력해주세요.",
                        alignment: .leading,
                        lineLimit: 2
                    )
                    .padding(.bottom, 44)
                
                PawTitleLabel
                    .semi14(
                        "이름",
                        color: .grayScale02,
                        alignment: .leading,
                        lineLimit: 2
                    )
                
                PawTextField(
                    "이름을 입력해 주세요.",
                    text: $viewModel.name,
                    isError: $viewModel.isError,
                    errorMessage: "공백없이 1자 이상 5자 이하로 입력해주세요."
                )
                .padding(.bottom, 28)
                .onChange(of: viewModel.name) { oldValue, newValue in
                    viewModel.updateName(newValue)
                }
                
                PawTitleLabel
                    .semi14(
                        "종류",
                        color: .grayScale02,
                        alignment: .leading,
                        lineLimit: 2
                    )
                HStack(spacing: 12) {
                    PawChoiceButton(
                        "강아지",
                        isEnabled: viewModel.isDogEnabled,
                        horizontalPadding: 0
                    ) {
                        viewModel.selectDog()
                    }
                    
                    PawChoiceButton(
                        "고양이",
                        isEnabled: viewModel.isCatEnabled,
                        horizontalPadding: 0
                    ) {
                        viewModel.selectCat()
                    }
                }
            }
            .padding(20)
            
            Spacer()
            
            PawPrimaryButton("시작하기", isEnabled: viewModel.isValidInput) {
                viewModel.tapStartButton()
            }
        }
    }
}

#Preview {
    PetInfoView()
}
