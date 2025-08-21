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
    case pawcutFrameSelection
    case pawcutSelection
    case setting
    case soundSetting
    case fixPetInfo
    case inquiry
    case terms
    case petInfo
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .home:
            MainView()
        case .archive:
            ArchiveView()
        case .photoDetails(let date, let index):
            PhotoDetailsView(initialDate: date, initialIndex: index)
        case .pawcutFrameSelection:
            PawcutFrameView()
        case .setting:
            SettingView()
        case .soundSetting:
            SoundSettingView()
        case .fixPetInfo:
            FixPetInfoView()
        case .inquiry:
            EmptyView() // TODO: InquiryView 구현 예정
        case .terms:
            EmptyView() // TODO: TermsView 구현 예정
        case .petInfo:
            PetInfoView()
        case .pawcutSelection:
            PawcutSelectionView()
        }
    }
}
