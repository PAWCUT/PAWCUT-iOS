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
            PetInfoContentView(viewModel: viewModel)

            Spacer()

            PawPrimaryButton("시작하기", isEnabled: viewModel.isValidInput) {
                viewModel.tapStartButton()
            }
        }
    }
}

struct PetInfoContentView: View {
    @ObservedObject var viewModel: PetInfoViewModel

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
                .padding(.top, 80)

            PawTitleLabel
                .semi14(
                    "이름",
                    color: .grayScale02,
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

            PetTypeSelectionView<PetInfoViewModel>(viewModel: viewModel)

            Spacer()
        }
        .padding(20)
    }
}

#Preview {
    PetInfoView()
}
