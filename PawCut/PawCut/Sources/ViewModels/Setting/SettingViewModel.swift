//
//  SettingViewModel.swift
//  PawCut
//
//  Created by donghee on 8/19/25.
//

import Foundation

@MainActor
class SettingViewModel: ObservableObject {
    private let navigationManager = NavigationManager.shared
    
    func navigateToProfileEdit() {
        navigationManager.navigate(to: .main(.fixPetInfo))
    }
    
    func navigateToSoundEdit() {
        navigationManager.navigate(to: .main(.soundSetting))
    }
    
    func navigateToCustomerInquiry() {
        navigationManager.navigate(to: .main(.inquiry))
    }
    
    func navigateToServiceTerms() {
        navigationManager.navigate(to: .main(.terms))
    }
}
