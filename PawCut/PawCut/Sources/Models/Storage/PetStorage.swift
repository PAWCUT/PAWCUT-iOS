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
    
    func getPetType() -> PetType {
        guard let typeRawValue = userDefaults.string(forKey: StorageKeys.petType),
              let type = PetType(rawValue: typeRawValue) else {
            return .dog // 기본값은 강아지
        }
        return type
    }
    
    func setPetType(_ type: PetType) {
        userDefaults.set(type.rawValue, forKey: StorageKeys.petType)
    }
    
    func getSelectedAudioFileName(for petType: PetType) -> String? {
        let key = getSelectedAudioFileKey(for: petType)
        return userDefaults.string(forKey: key)
    }
    
    func setSelectedAudioFileName(_ fileName: String, for petType: PetType) {
        let key = getSelectedAudioFileKey(for: petType)
        userDefaults.set(fileName, forKey: key)
    }
    
    private func getSelectedAudioFileKey(for petType: PetType) -> String {
        return "selectedAudioFile_\(petType.rawValue)"
    }
}
