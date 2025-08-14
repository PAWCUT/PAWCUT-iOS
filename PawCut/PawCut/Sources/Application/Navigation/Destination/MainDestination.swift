//
//  MainDestination.swift
//  PawCut
//
//  Created by Luminouxx on 8/11/25.
//

import SwiftUI

enum MainDestination: NavigationDestination {
    case home
    case archive
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .home:
            // TODO: HomeView로 수정 예정
            EmptyView()
        case .archive:
            ArchiveView()
        }
    }
}
