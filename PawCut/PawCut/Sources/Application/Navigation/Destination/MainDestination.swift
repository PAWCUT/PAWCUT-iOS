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
        case .pawcutFrameSelection:
            PawcutFrameView()
        case .setting:
            SettingView()
        case .soundSetting:
            SoundSettingView()
        case .fixPetInfo:
            PetInfoView() // TODO: FixPetInfoView로 수정 예정
        case .inquiry:
            EmptyView() // TODO: InquiryView 구현 예정
        case .terms:
            EmptyView() // TODO: TermsView 구현 예정
        case .petInfo:
            PetInfoView()
        }
    }
}
