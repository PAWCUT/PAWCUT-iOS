//
//  PawNavigationBar.swift
//  PawCut
//
//  Created by Luminouxx on 10/26/25.
//

import SwiftUI

struct PawNavigationBar: View {
    let style: PawNavigationStyle
    let title: String
    let onBackTapped: () -> Void
    let trailingItem: AnyView?
    
    var body: some View {
        ZStack {
            if style.showsTitle {
                Text(title)
                    .lineLimit(1)
                    .pretendardFont(size: ._16, weight: .semibold)
                    .foregroundColor(style.foregroundColor)
            }
            
            HStack(spacing: 0) {
                Button(action: onBackTapped) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(style.foregroundColor)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                
                Spacer()
                
                if let trailingItem = trailingItem {
                    trailingItem
                } else {
                    Color.clear
                        .frame(width: 44, height: 44)
                }
            }
        }
        .frame(height: style.height)
        .frame(maxWidth: .infinity)
        .background(style.backgroundColor)
    }
}
#Preview("백버튼만") {
    Text("백버튼")
        .pawNavigationBar()
}

#Preview("인라인") {
    Text("인라인")
        .pawNavigationBar()
        .pawNavigationStyle(.inline)
        .pawNavigationTitle("인라인")
}

#Preview("Inline + 아이템 1개") {
    Text("Content")
        .pawNavigationBar()
        .pawNavigationStyle(.inline)
        .pawNavigationTitle("아이템")
        .pawNavigationTrailingItems(
            NavigationIconItem(systemName: "gearshape") { }
        )
}

#Preview("Inline + 아이템 2개") {
    Text("아이템 2개")
        .pawNavigationBar()
        .pawNavigationStyle(.inlineWithItem)
        .pawNavigationTitle("아이템")
        .pawNavigationTrailingItems(
            NavigationIconItem(systemName: "gearshape") { },
            NavigationIconItem(systemName: "gearshape") { }
        )
}

#Preview("Camera") {
    Text("카메라")
        .pawNavigationBar()
        .pawNavigationStyle(.camera)
        .pawNavigationTitle("안녕")
        .pawNavigationTrailingItems(
            NavigationIconItem(imageName: "pawcut_sound") { },
            NavigationIconItem(imageName: "flash_dark") { }
        )
}
