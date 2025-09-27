//
//  IconButton.swift
//  PawCut
//
//  Created by Luminouxx on 8/18/25.
//

import SwiftUI

struct IconButton: View {
    
    let imageName: String
    let imageSize: CGSize
    let buttonSize: CGSize
    let action: () -> Void
    
    init(
        imageName: String,
        imageSize: CGSize = CGSize(width: 28, height: 28),
        buttonSize: CGSize = CGSize(width: 30, height: 30),
        action: @escaping () -> Void
    ) {
        self.imageName = imageName
        self.imageSize = imageSize
        self.buttonSize = buttonSize
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: imageSize.width, height: imageSize.height)
                .frame(width: buttonSize.width, height: buttonSize.height)
        }
    }
}

#Preview {
    IconButton(imageName: "gearshape") {
        
    }
    IconButton(imageName: "archivebox") {
        
    }
}
