//
//  NavigationManager.swift
//  PawCut
//
//  Created by Luminouxx on 8/11/25.
//

import SwiftUI

@MainActor
class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    @Published var root: AppDestination?
    @Published var hasCompletedOnboarding: Bool = false
    
    static let shared = NavigationManager()
    
    private init() {
        // TODO: 온보딩 정보 불러옴
        root = .onboarding(.firstOnboarding)
    }
    
    func navigate(to destination: AppDestination) {
        path.append(destination)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func startMainFlow() {
        path = NavigationPath()
        root = .main(.home)
    }
    
    func getRootView() -> some View {
        return root?.view()
    }
}
