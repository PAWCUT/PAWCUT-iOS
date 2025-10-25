//
//  PhotoImportPickerView.swift
//  PawCut
//
//  Created by Jay on 10/19/25.
//

import PhotosUI
import SwiftUI

struct PhotoImportPickerView: View {
    @Binding var importImages: [UIImage]
    var tapPawcutSelectionButton: () -> Void

    @State private var showPicker = false
    
    var body: some View {
        VStack(spacing: 0) {
            PawTitleLabel.bold18("이미 남겨둔 순간이 있나요?")
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button{
                showPicker = true
            } label: {
                HStack(spacing: 0) {
                    Image("import_photo_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color("PointPurple03"))
                        )
                        .padding(16)

                    VStack(alignment: .leading, spacing: 4) {
                        PawTitleLabel.semi17("앨범에서 불러오기")

                        PawButtonLabel.med12(
                            "저장된 사진으로 포우컷 만들기",
                            color: .grayScale04
                        )
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.grayScale01)
                        .padding(16)
                }
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.1), radius: 6, x: 0, y: 0)
                .padding(.top, 18)
                .padding(.horizontal, 20)
            }
            .fullScreenCover(isPresented: $showPicker) {
                FullScreenPhotoPickerView { uiImages in
                    importImages = uiImages
                    tapPawcutSelectionButton()
                }
                .ignoresSafeArea()
            }
        }
        .padding(.vertical, 40)
    }
}
