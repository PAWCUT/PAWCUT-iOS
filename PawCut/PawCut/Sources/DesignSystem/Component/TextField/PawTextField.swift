//
//  PawTextField.swift
//  PawCut
//
//  Created by Luminouxx on 7/15/25.
//

import SwiftUI

struct PawTextField: View {
    
    @Binding private var text: String
    @Binding private var isError: Bool
    @FocusState private var isFocused: Bool
    
    private let placeholder: String
    private let errorMessage: String?
    
    init(
        _ placeholder: String,
        text: Binding<String>,
        isError: Binding<Bool>,
        errorMessage: String? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self._isError = isError
        self.errorMessage = errorMessage
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                TextField(placeholder, text: $text)
                    .pretendardFont(size: ._14, weight: .semibold)
                    .focused($isFocused)
                    .foregroundColor(isFocused ? .grayScale01 : .grayScale04)
                
                if isFocused && !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.grayScale04)
                    }
                }
            }
            .padding(EdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16))
            .background(.grayScale05)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isError ? .pointRed02 : .grayScale05, lineWidth: 1)
            )
            
            if isError, let errorMessage = errorMessage {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.pointRed01)
                        .font(.system(size: 12))
                    
                    Text(errorMessage)
                        .pretendardFont(size: ._12, weight: .medium)
                        .foregroundColor(.pointRed01)
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        PawTextField("이름을 입력해 주세요", text: .constant(""), isError: .constant(false))
        
        PawTextField(
            "이름을 입력해 주세요",
            text: .constant("잘못된 입력"),
            isError: .constant(true),
            errorMessage: "공백없이 1자 이상 5자 이하로 입력해주세요."
        )
    }
    .padding(20)
}
