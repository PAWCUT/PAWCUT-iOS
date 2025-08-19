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
    case pawcutFrameSelection
    case setting
    case petInfo
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .home:
            MainView()
        case .archive:
            ArchiveView()
        case .pawcutFrameSelection:
            PawcutFrameView()
        case .setting:
            SettingView()
        case .petInfo:
            PetInfoView()
        }
    }
}
