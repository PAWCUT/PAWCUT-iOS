//
//  ImageComponent.swift
//  PawCut
//
//  Created by Ethan on 7/25/25.
//

import SwiftUI

struct ImageComponent: View {
    
    let imageName: String
    let size: CGSize
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: size.width, height: size.height)
    }
}


#Preview {
    ImageComponent(
            imageName: "logo_white",
            size: CGSize(width: 180, height: 200)
        )
}
