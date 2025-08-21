//
//  UserDefaultsStorage.swift
//  PawCut
//
//  Created by Luminouxx on 8/21/25.
//

import Foundation

final class UserStorage: UserStorageManaging {

    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func getIsOnboardingCompleted() -> Bool {
        return userDefaults.bool(forKey: StorageKeys.isOnboardingCompleted)
    }
    
    func setIsOnboardingCompleted(_ isCompleted: Bool) {
        userDefaults.set(isCompleted, forKey: StorageKeys.isOnboardingCompleted)
    }
}
