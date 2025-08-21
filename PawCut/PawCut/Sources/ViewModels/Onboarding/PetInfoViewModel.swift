//
//  PetInfoViewModel.swift
//  PawCut
//
//  Created by donghee on 8/16/25.
//

import Foundation

@MainActor
class PetInfoViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var selectedType: PetType? = nil
    @Published var isDogEnabled = false
    @Published var isCatEnabled = false
    @Published var isError: Bool = false
    
    private let navigationManager: NavigationManager
    private let petStorage: PetStorageManaging
    
    init() {
        self.navigationManager = NavigationManager.shared
        self.petStorage = UserDefaultsStorage()
    }
    
    var isValidInput: Bool {
        !name.isEmpty && name.count <= 5 && selectedType != nil
    }

    func updateName(_ newName: String) {
        name = newName
        validateName()
    }

    func selectDog() {
        isDogEnabled = true
        isCatEnabled = false
        selectedType = .dog
    }

    func selectCat() {
        isDogEnabled = false
        isCatEnabled = true
        selectedType = .cat
    }

    func tapStartButton() {
        guard isValidInput else { return }
        petStorage.setPetName(name)
        navigationManager.startMainFlow()
    }

    private func validateName() {
        if name.count > 5 || name.isEmpty {
            isError = true
        } else {
            isError = false
        }
    }
}
