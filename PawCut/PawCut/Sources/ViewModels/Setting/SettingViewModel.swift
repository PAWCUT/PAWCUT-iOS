//
//  SettingViewModel.swift
//  PawCut
//
//  Created by donghee on 8/19/25.
//

import Foundation

@MainActor
class SettingViewModel: ObservableObject {
    @Published var navigateToFixPetInfo = false
    @Published var navigateToSoundSetting = false
    @Published var navigateToInquiry = false
    @Published var navigateToTerms = false
    
    func navigateToProfileEdit() {
        navigateToFixPetInfo = true
    }
    
    func navigateToSoundEdit() {
        navigateToSoundSetting = true
    }
    
    func navigateToCustomerInquiry() {
        navigateToInquiry = true
    }
    
    func navigateToServiceTerms() {
        navigateToTerms = true
    }
}
