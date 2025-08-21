//
//  UserDefaultsStorage.swift
//  PawCut
//
//  Created by Luminouxx on 8/21/25.
//

import Foundation

final class PetStorage: PetStorageManaging {
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func getPetName() -> String {
        return userDefaults.string(forKey: StorageKeys.petName) ?? "이름 없음"
    }
    
    func setPetName(_ name: String) {
        userDefaults.set(name, forKey: StorageKeys.petName)
    }
}
