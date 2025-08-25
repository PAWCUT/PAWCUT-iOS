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
    case photoDetails(date: Date, index: Int)
    case pawcutFrameSelection(images: [UIImage])
    case pawcutSelection(images: [UIImage])
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
        case .photoDetails(let date, let index):
            PhotoDetailsView(initialDate: date, initialIndex: index)
        case .pawcutFrameSelection(let images):
            PawcutFrameView(images: images)
        case .setting:
            SettingView()
        case .soundSetting:
            SoundSettingView()
        case .fixPetInfo:
            FixPetInfoView()
        case .petInfo:
            PetInfoView()
        case .pawcutSelection(let images):
            PawcutSelectionView(images: images)
        case .tip:
            PawcutTipView()
        case .ready:
            PawcutReadyView()
        case .camera:
            PawcutCameraView()
        }
    }
}
