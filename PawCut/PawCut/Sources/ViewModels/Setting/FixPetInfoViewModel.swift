//
//  FixPetInfoViewModel.swift
//  PawCut
//
//  Created by Luminouxx on 8/20/25.
//

import Foundation

// MARK: - PetTypeSelectable Extension

extension FixPetInfoViewModel: PetTypeSelectable {}

@MainActor
class FixPetInfoViewModel: ObservableObject {
    private let navigationManager = NavigationManager.shared
    
    @Published var name: String = ""
    @Published var selectedType: PetType? = nil
    @Published var isDogEnabled = false
    @Published var isCatEnabled = false
    @Published var isError: Bool = false
    
    private let petStorage: PetStorageManaging
    
    init() {
        self.petStorage = PetStorage()
        loadPetInfo()
    }
    
    private func loadPetInfo() {
        let savedName = petStorage.getPetName()
        if savedName != "이름 없음" { // 빈 값인지
            name = savedName
        }
        
        let savedType = petStorage.getPetType()
        selectedType = savedType
        
        switch savedType {
        case .dog:
            isDogEnabled = true
            isCatEnabled = false
        case .cat:
            isDogEnabled = false
            isCatEnabled = true
        }
    }
    
    var isValidInput: Bool {
        !name.isEmpty && name.count <= 5 && selectedType != nil
    }
    
    func updateName(_ newName: String) {
        name = newName
        validateName()
    }
    
    func didSelectDog() {
        isDogEnabled = true
        isCatEnabled = false
        selectedType = .dog
    }
    
    func didSelectCat() {
        isDogEnabled = false
        isCatEnabled = true
        selectedType = .cat
    }
    
    func tapSaveButton() {
        guard isValidInput else { return }
        petStorage.setPetName(name)
        petStorage.setPetType(selectedType ?? .dog)
        navigationManager.pop()
    }
    
    private func validateName() {
        if name.count > 5 || name.isEmpty {
            isError = true
        } else {
            isError = false
        }
    }
}
