//
//  UserStorageManaging.swift
//  PawCut
//
//  Created by Luminouxx on 8/21/25.
//

import Foundation

protocol UserStorageManaging {
    func getIsOnboardingCompleted() -> Bool
    func setIsOnboardingCompleted(_ isCompleted: Bool)
}
