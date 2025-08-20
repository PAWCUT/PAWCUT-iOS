//
//  SoundSettingView.swift
//  PawCut
//
//  Created by donghee on 8/19/25.
//

import SwiftUI

struct SoundSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SoundSettingViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // 타이틀 영역
                HStack {
                    VStack(alignment: .leading) {
                        PawTitleLabel
                            .bold24(
                                "원하는\n소리를 선택해주세요.",
                                alignment: .leading,
                                lineLimit: 2
                            )
                            .frame(height: 70, alignment: .topLeading)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 32)
                
                // 벨소리 선택 영역
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(0..<viewModel.soundNames.count, id: \.self) { index in
                            PawSelectableButton(
                                title: viewModel.soundNames[index],
                                isSelected: viewModel.selectedSoundIndex == index
                            ) {
                                viewModel.selectSound(at: index)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
                
                Spacer()
                
                // 저장하기 버튼
                PawPrimaryButton("저장하기", isEnabled: true) {
                    viewModel.saveSelection()
                }
            }
            .navigationTitle("소리")
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
    SoundSettingView()
}
