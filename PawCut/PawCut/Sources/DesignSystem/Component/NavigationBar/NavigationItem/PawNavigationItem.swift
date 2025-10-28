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
