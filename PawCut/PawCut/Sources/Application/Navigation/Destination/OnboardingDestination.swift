//
//  NavigationDestination.swift
//  PawCut
//
//  Created by Luminouxx on 8/11/25.
//
import SwiftUI

enum OnboardingDestination: NavigationDestination {
    case firstOnboarding
    case secondOnboarding
    case thirdOnboarding
    case petInfo
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .firstOnboarding:
            FirstOnboardingView()
        case .secondOnboarding:
            SecondOnboardingView()
                .navigationBarBackButtonHidden(true)
        case .thirdOnboarding:
            ThirdOnboardingView()
                .navigationBarBackButtonHidden(true)
        case .petInfo:
            PetInfoView()
                .navigationBarBackButtonHidden(true)
        }
    }
}
