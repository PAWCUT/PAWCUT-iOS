//
//  NavigationDestination.swift
//  PawCut
//
//  Created by Luminouxx on 8/11/25.
//
import SwiftUI

enum OnboardingDestination: NavigationDestination {
    case onboarding
    case petInfo

    @ViewBuilder
    func view() -> some View {
        switch self {
        case .onboarding:
            OnboardingView()
        case .petInfo:
            PetInfoView()
                .navigationBarBackButtonHidden(true)
        }
    }
}
