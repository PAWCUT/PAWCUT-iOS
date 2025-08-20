//
//  SettingViewModel.swift
//  PawCut
//
//  Created by donghee on 8/19/25.
//

import Foundation
import UIKit

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
        guard let url = URL(string: "https://open.kakao.com/o/s4Za1sNh") else { return }
        UIApplication.shared.open(url)
    }
    
    func navigateToServiceTerms() {
        navigationManager.navigate(to: .main(.terms))
    }
}
