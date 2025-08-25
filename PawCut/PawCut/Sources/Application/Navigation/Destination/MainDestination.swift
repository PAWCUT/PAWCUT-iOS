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
    case pawcutSelection
    case setting
    case soundSetting
    case fixPetInfo
    case petInfo
    case tip
    case ready
    case camera
    
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
        case .soundSetting:
            SoundSettingView()
        case .fixPetInfo:
            FixPetInfoView()
        case .petInfo:
            PetInfoView()
        case .pawcutSelection:
            PawcutSelectionView()
        case .tip:
            PawcutTipView()
        case .ready:
            PawcutReadyView()
        case .camera:
            PawcutCameraView()
        }
    }
}
