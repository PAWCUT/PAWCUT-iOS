//
//  PawSettingLabel.swift
//  PawCut
//
//  Created by donghee on 8/19/25.
//

import SwiftUI

struct PawSettingRow: View {
    let title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                PawBodyLabel
                    .med16(
                        title,
                        color: .grayScale01,
                        alignment: .leading,
                        lineLimit: 1
                    )
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .contentShape(Rectangle())
        }
        .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
        .padding(.horizontal, 20)
    }
}

struct PawSectionSeparator: View {
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: 8)
        }
    }
}

#Preview {
    VStack {
        PawSettingRow(title: "프로필 수정") {
            print("프로필 수정 탭")
        }
        PawSettingRow(title: "소리 수정") {
            print("소리 수정 탭")
        }
        PawSectionSeparator()
    }
}
