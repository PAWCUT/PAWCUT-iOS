//
//  MainViewModel.swift
//  PawCut
//
//  Created by Luminouxx on 8/18/25.
//

import Foundation

@MainActor
class MainViewModel: ObservableObject {
    @Published var petName: String = ""
    private let navigationManager = NavigationManager.shared
    private let petStorage: PetStorage = PetStorage()
    
    init() {
        self.petName = petStorage.getPetName()
    }
    
    let currentPage: Int = 0
    
    func tapCaptureButton() {
        navigationManager.navigate(to: .main(.tip))
    }
    
    func tapAchiveButton() {
        navigationManager.navigate(to: .main(.archive))
    }
    
    func tapSettingButton() {
        navigationManager.navigate(to: .main(.setting))
    }
    
    func tapNextButton() {
        navigationManager.navigate(to: .onboarding(.onboarding))
    }
    
    func getPetName() -> String {
        return self.petName
    }
    
    func updatePetInfo() {
        petName = petStorage.getPetName()
    }
}
