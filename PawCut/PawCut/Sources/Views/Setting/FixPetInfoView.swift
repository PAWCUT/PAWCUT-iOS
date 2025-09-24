//
//  FixPetInfoView.swift
//  PawCut
//
//  Created by donghee on 8/18/25.
//

import SwiftUI

struct FixPetInfoView: View {
    @StateObject private var viewModel = FixPetInfoViewModel()

    var body: some View {
        VStack {
            FixPetInfoContentView(viewModel: viewModel)

            Spacer()

            PawPrimaryButton("저장하기", isEnabled: viewModel.isValidInput) {
                viewModel.tapSaveButton()
            }
        }
    }
}

struct FixPetInfoContentView: View {
    @ObservedObject var viewModel: FixPetInfoViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PawTitleLabel
                .bold24(
                    "반려동물의\n정보를 입력해주세요.",
                    alignment: .leading,
                    lineLimit: 2
                )
                .frame(height: 70, alignment: .topLeading)
                .padding(.bottom, 44)
                .padding(.top, 56)

            PawTitleLabel
                .semi14(
                    "이름",
                    color: .grayScale01,
                    alignment: .leading,
                    lineLimit: 2
                )
                .padding(.bottom, 8)

            PawTextField(
                "이름을 입력해 주세요.",
                text: $viewModel.name,
                isError: $viewModel.isError,
                errorMessage: "공백없이 1자 이상 5자 이하로 입력해주세요."
            )
            .padding(.bottom, 28)
            .onChange(of: viewModel.name) { _, newName in
                viewModel.updateName(newName)
            }

            PawTitleLabel
                .semi14(
                    "종류",
                    color: .grayScale02,
                    alignment: .leading,
                    lineLimit: 2
                )
                .padding(.bottom, 8)

            PetTypeSelectionView(
                isDogEnabled: $viewModel.isDogEnabled,
                isCatEnabled: $viewModel.isCatEnabled,
                didSelectDog: { viewModel.didSelectDog() },
                didSelectCat: { viewModel.didSelectCat() }
            )

            Spacer()
        }
        .padding(20)
    }
}

#Preview {
    FixPetInfoView()
}
