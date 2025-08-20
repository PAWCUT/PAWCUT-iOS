//
//  ThirdOnboardingViewModel.swift
//  PawCut
//
//  Created by Luminouxx on 8/11/25.
//

import Foundation

@MainActor
class ThirdOnboardingViewModel: ObservableObject {
    
    private let navigationManager = NavigationManager.shared
    
    let currentPage: Int = 2
    
    func tapNextButton() {
        navigationManager.navigate(to: .onboarding(.petInfo))
    }
}
