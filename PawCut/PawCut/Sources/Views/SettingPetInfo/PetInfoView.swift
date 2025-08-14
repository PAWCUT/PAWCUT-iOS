//
//  PetInfoView.swift
//  PawCut
//
//  Created by donghee on 8/13/25.
//

import SwiftUI

struct PetInfoView: View {
    @State private var isError: Bool = true
    @State private var name: String = ""
    @State private var selectedType: PetType? = nil
    @State private var isDogEnabled = false
    @State private var isCatEnabled = false


    var body: some View {
        HStack {
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
                //Text 입력칸
                PawTextField(
                    "이름을 입력해 주세요.",
                    text: $name,
                    isError: $isError,
                    errorMessage: "공백없이 1자 이상 5자 이하로 입력해주세요."
                )
                .padding(.bottom, 28)
                .onChange(of: name) { oldValue, newValue in
                    if newValue.count > 5 || newValue.isEmpty {
                        self.isError = true
                    } else {
                        self.isError = false
                    }
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
                        isEnabled: isDogEnabled,
                        horizontalPadding: 0
                    ) {
                        isDogEnabled.toggle()

                    }
                    PawChoiceButton(
                        "고양이",
                        isEnabled: isCatEnabled,
                        horizontalPadding: 0
                    ) {
                        isCatEnabled.toggle()
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        PawSecondaryButton("시작하기") {

        }
    }
}

#Preview {
    PetInfoView()
}
