//
//  OnboardingViewModel.swift
//  PawCut
//
//  Created by Luminouxx on 8/11/25.
//

import Foundation

@MainActor
class FirstOnboardingViewModel: ObservableObject {
    
    private let navigationManager = NavigationManager.shared
    
    let currentPage: Int = 0
    
    func tapNextButton() {
        navigationManager.navigate(to: .onboarding(.secondOnboarding))
    }
}
