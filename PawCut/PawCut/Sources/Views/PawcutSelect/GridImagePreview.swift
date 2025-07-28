//
//  Untitled.swift
//  PawCut
//
//  Created by Jay on 7/28/25.
//
import SwiftUI

struct GridImagePreview: View {
    let images: [UIImage]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<2, id: \.self) { row in
                if row == 1 {
                    Spacer().frame(height: 8)
                }
                
                HStack(spacing: 0) {
                    ForEach(0..<2, id: \.self) { col in
                        if col == 1 {
                            Spacer().frame(width: 5)
                        }
                        
                        let index = row * 2 + col
                        if index < images.count {
                            Image(uiImage: images[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 99.6, height: 133.6)
                                .clipped()
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 99.6, height: 133.6)
                                .overlay(
                                    Rectangle()
                                        .stroke(Color("GrayScale01"), lineWidth: 1)
                                )
                        }
                    }
                }
            }
            
            Image("logo_black")
                .resizable()
                .scaledToFit()
                .frame(height: 19.21)
                .padding(.top, 13.11)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
