//
//  FixPetInfoView.swift
//  PawCut
//
//  Created by donghee on 8/18/25.
//



import SwiftUI

struct FixPetInfoView: View {
    @StateObject private var viewModel = PetInfoViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        PawTitleLabel
                            .bold24(
                                "반려동물의\n정보를 입력해주세요.",
                                alignment: .leading,
                                lineLimit: 2
                            )
                            .frame(height: 70,alignment: .topLeading)
                            .padding(.bottom, 44)
                            .padding(.top, 20)
                        PawTitleLabel
                            .semi14(
                                "이름",
                                color: .grayScale02,
                                alignment: .leading,
                                lineLimit: 2
                            )
                        //Text 입력칸
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
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                
                PawPrimaryButton("시작하기", isEnabled: viewModel.isValidInput) {
                    viewModel.startApp()
                }
            }
            .navigationTitle("프로필")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.grayScale01)
                    }
                }
            }
        }
    }
}

#Preview {
    FixPetInfoView()
}
