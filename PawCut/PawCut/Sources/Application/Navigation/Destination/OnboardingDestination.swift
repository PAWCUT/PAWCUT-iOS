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
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .firstOnboarding:
            FirstOnboardingView()
        case .secondOnboarding:
            SecondOnboardingView()
        case .thirdOnboarding:
            ThirdOnboardingView()
        }
    }
}
