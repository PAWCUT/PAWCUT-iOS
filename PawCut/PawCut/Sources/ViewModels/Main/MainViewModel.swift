//
//  MainViewModel.swift
//  PawCut
//
//  Created by Luminouxx on 8/18/25.
//

import Foundation

@MainActor
class MainViewModel: ObservableObject {
    
    private let navigationManager = NavigationManager.shared
    
    let currentPage: Int = 0
    
    func tapCaptureButton() {
        // TODO: 화면 연결
    }
    
    func tapAchiveButton() {
        navigationManager.navigate(to: .main(.archive))
    }
    
    func tapSettingButton() {
        navigationManager.navigate(to: .main(.setting))
    }
    
    func tapNextButton() {
        navigationManager.navigate(to: .onboarding(.secondOnboarding))
    }
}
