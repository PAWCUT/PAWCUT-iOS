//
//  PawcutDestination.swift
//  PawCut
//
//  Created by Jay on 8/13/25.
//

import SwiftUI

enum PawcutImageSelectionDestination: NavigationDestination {
    case pawcutFrameSelection

    @ViewBuilder
    func view() -> some View {
        switch self {
        case .pawcutFrameSelection:
            PawcutFrameView()
        }
    }
}
