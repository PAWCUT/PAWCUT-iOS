//
//  ArchiveDestination.swift
//  PawCut
//
//  Created by taeni on 8/13/25.
//

import SwiftUI

enum ArchiveDestination: NavigationDestination {
    case archive
    case photoDetails
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .archive:
            ArchiveView()
        case .photoDetails:
            ArchiveView()
        }
    }
}
