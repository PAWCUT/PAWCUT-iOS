//
//  PawNavigationItem.swift
//  PawCut
//
//  Created by Luminouxx on 10/28/25.
//

import SwiftUI

protocol PawNavigationItem: View {
    var action: () -> Void { get }
    var image: Image { get }
}

struct PawNavigationIconItem: PawNavigationItem {
    let action: () -> Void
    let image: Image
    
    init(systemName: String, action: @escaping () -> Void) {
        self.image = Image(systemName: systemName)
        self.action = action
    }
    
    init(imageName: String, action: @escaping () -> Void) {
        self.image = Image(imageName)
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.grayScale01)
                .frame(width: 44, height: 44)
        }
    }
}
