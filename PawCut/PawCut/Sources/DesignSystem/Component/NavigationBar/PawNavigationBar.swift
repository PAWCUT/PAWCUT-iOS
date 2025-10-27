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
        HStack(alignment: .center, spacing: 0) {
            Button(action: onBackTapped) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(style.foregroundColor)
                    .frame(width: 33, height: 44)
            }
            
            Spacer()
            
            if style.showsTitle {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(style.foregroundColor)
            }
            
            Spacer()
            
            if let trailingItem = trailingItem {
                trailingItem
                    .frame(width: 44, height: 44)
            } else {
                Color.clear
                    .frame(width: 44, height: 44)
            }
        }
        .frame(height: style.height)
        .background(style.backgroundColor)
    }
}

#Preview("Only Back Button") {
    VStack {
        Text("Content")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .pawNavigationBar()
}

#Preview("Inline") {
    VStack {
        Text("Content")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .pawNavigationBar()
    .pawNavigationStyle(.inline)
    .pawNavigationTitle("인라인")
}

#Preview("Inline With Item") {
    VStack {
        Text("Content")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .pawNavigationBar()
    .pawNavigationStyle(.inlineWithItem)
    .pawNavigationTitle("아이템")
    .pawNavigationTrailingItem {
        Button(action: {}) {
            Image(systemName: "play.circle")
                .font(.system(size: 24))
                .foregroundColor(.white)
        }
    }
}

#Preview("Camera") {
    ZStack {
        Color.black.ignoresSafeArea()
        Text("Camera Preview")
            .foregroundColor(.white)
    }
    .pawNavigationBar()
    .pawNavigationStyle(.camera)
    .pawNavigationTrailingItem {
        Button(action: {}) {
            Image(systemName: "play.circle")
                .font(.system(size: 24))
                .foregroundColor(.white)
        }
        Button(action: {}) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 20))
                .foregroundColor(.white)
        }
    }
    .pawNavigationTitle("안녕")
}
