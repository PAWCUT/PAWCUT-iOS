//
//  MainViewModel.swift
//  PawCut
//
//  Created by Luminouxx on 8/18/25.
//

import PhotosUI
import SwiftUI

@MainActor
class MainViewModel: ObservableObject {
    @Published var petName: String = ""
    @Published var importImages: [UIImage] = []

    private let navigationManager = NavigationManager.shared
    private let petStorage: PetStorage = PetStorage()
    private let selectedPetType: PetType

    init() {
        self.petName = petStorage.getPetName()
        self.selectedPetType = petStorage.getPetType()
    }
    
    var mainImageName: String {
        return "main_" + selectedPetType.filePrefix + "photo"
    }
    
    var importImageName: String {
        return "import_photo_" + selectedPetType.filePrefix + "icon"
    }

    let currentPage: Int = 0

    func tapCaptureButton() {
        navigationManager.navigate(to: .main(.tip))
    }

    func tapAchiveButton() {
        navigationManager.navigate(to: .main(.archive))
    }

    func tapPawcutSelectionButton() {
        navigationManager.navigate(
            to: .main(
                .pawcutSelection(images: importImages, entryPoint: .photoPicker)
            )
        )

        importImages = []
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
