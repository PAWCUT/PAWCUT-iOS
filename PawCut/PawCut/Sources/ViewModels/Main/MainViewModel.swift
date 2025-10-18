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
    @Published var importImages: [PhotosPickerItem] = []

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

    func tapPawcutSelectionButton() {
        Task {
            var images: [UIImage] = []
            for item in importImages {
                if let data = try? await item.loadTransferable(type: Data.self),
                    let image = UIImage(data: data)
                {
                    images.append(image)
                }
            }

            navigationManager.navigate(
                to: .main(
                    .pawcutSelection(images: images, entryPoint: .photoPicker)
                )
            )

            await MainActor.run {
                self.importImages = []
            }
        }
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
