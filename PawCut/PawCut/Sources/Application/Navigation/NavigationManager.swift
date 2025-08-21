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
    
    private var loginStorage: UserStorageManaging
    
    static let shared = NavigationManager()
    
    private init() {
        self.loginStorage = UserDefaultsStorage()
        setRootView()
    }
    
    func navigate(to destination: AppDestination) {
        path.append(destination)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func setStorage() {
        self.loginStorage = UserDefaultsStorage()
    }
    
    func setRootView() {
        let isOnboardingCompleted = loginStorage.getIsOnboardingCompleted()
        
        if isOnboardingCompleted {
            self.root = .main(.home)
        } else {
            self.root = .onboarding(.firstOnboarding)
        }
    }
    
    func getRootView() -> some View {
        return root?.view()
    }
    
    func startMainFlow() {
        path = NavigationPath()
        root = .main(.home)
    }
}
