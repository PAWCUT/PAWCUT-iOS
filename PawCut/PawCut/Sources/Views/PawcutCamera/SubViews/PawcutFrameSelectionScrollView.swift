//
//  PawcutFrameSelectionScrollView.swift
//  PawCut
//
//  Created by Jay on 9/23/25.
//

import SwiftUI

struct PawcutFrameSelectionScrollView: View {
    let frames: [FrameType]
    let selectedFrameIndex: Int?
    let onSelect: (Int) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(frames.indices, id: \.self) { index in
                    let frame = frames[index]
                    let isSelected =
                        index == selectedFrameIndex

                    if let image = UIImage(named:frame.frameScrollImageName) {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .strokeBorder(
                                        isSelected
                                            ? Color.pointPurple01
                                            : .clear,
                                        lineWidth: 2
                                    )
                            )
                            .onTapGesture {
                                onSelect(index)
                            }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 31)
        .padding(.leading, 4)
    }
}
