//
//  MainHeaderView.swift
//  PawCut
//
//  Created by Jay on 10/19/25.
//

import SwiftUI

struct MainHeaderView: View {
    var tapAchiveButton: () -> Void
    var tapSettingButton: () -> Void

    var body: some View {
        HStack {
            ImageComponent(
                imageName: "logo_black",
                size: CGSize(width: 83, height: 33)
            )
            Spacer()

            IconButton(imageName: "archivebox") {
                tapAchiveButton()
            }
            .padding(.trailing, -4)

            IconButton(imageName: "gearshape") {
                tapSettingButton()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(Color("PointPurple02"))
                .ignoresSafeArea()
        )
    }
}
