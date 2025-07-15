//
//  PawcutTopBar.swift
//  PawCut
//
//  Created by 광로 on 7/16/25.
//


import SwiftUI

struct PawcutTopBar: View {
    
    private let leftPadding: CGFloat
    private let rightPadding: CGFloat
    private let onArchiveTap: () -> Void
    private let onSettingsTap: () -> Void
    
    init(
        leftPadding: CGFloat = 20,
        rightPadding: CGFloat = 20,
        onArchiveTap: @escaping () -> Void = {},
        onSettingsTap: @escaping () -> Void = {}
    ) {
        self.leftPadding = leftPadding
        self.rightPadding = rightPadding
        self.onArchiveTap = onArchiveTap
        self.onSettingsTap = onSettingsTap
    }
    
    var body: some View {
        HStack(spacing: 0) {
            
            Image("logo_black")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 32)
                .padding(.leading, 20)
            
            Spacer()
            
            
            HStack(spacing: 16) {
                Button(action: onArchiveTap) {
                    Image("Archive_Icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: onSettingsTap) {
                    Image("Settings_Icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .frame(height: 20)
            .padding(.trailing, 20)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 12)
        .frame(height: 60)
    }
}

#Preview {
    VStack(spacing: 20) {
        
        PawcutTopBar(
            onArchiveTap: {
                print("Archive tapped")
            },
            onSettingsTap: {
                print("Settings tapped")
            }
        )
        
        Spacer()
    }
    .padding()
}
