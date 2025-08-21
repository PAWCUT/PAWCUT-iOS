//
//  StorageProtocol.swift
//  PawCut
//
//  Created by Luminouxx on 8/21/25.
//

import Foundation

protocol UserStorageManaging {
    func getIsOnboardingCompleted() -> Bool
    func setIsOnboardingCompleted(_ isCompleted: Bool)
}

protocol PetStorageManaging {
    func getPetName() -> String
    func setPetName(_ name: String)
}
