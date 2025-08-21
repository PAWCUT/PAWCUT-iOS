//
//  SoundSettingViewModel.swift
//  PawCut
//
//  Created by donghee on 8/19/25.
//

import Foundation

@MainActor
class SoundSettingViewModel: ObservableObject {
    @Published var selectedSoundIndex: Int = 0
    @Published var availableAudioFiles: [AudioFile] = []
    
    private let audioManager: AudioManager
    private let petStorage: PetStorageManaging
    
    private let navigationManager = NavigationManager.shared
    
    init(
        audioManager: AudioManager = AudioManager(),
        petStorage: PetStorageManaging = PetStorage()
    ) {
        self.audioManager = audioManager
        self.petStorage = petStorage
        
        setupAudioFiles()
        loadSelectedSound()
    }
    
    var soundNames: [String] {
        return availableAudioFiles.map { $0.displayName }
    }
    
    private func setupAudioFiles() {
        let currentPetType = petStorage.getPetType()
        availableAudioFiles = AudioFile.availableFiles(for: currentPetType)
    }
    
    private func loadSelectedSound() {
        let currentPetType = petStorage.getPetType()
        
        guard let savedFileName = petStorage.getSelectedAudioFileName(for: currentPetType),
              let savedAudioFile = AudioFile(rawValue: savedFileName) else {
            selectedSoundIndex = 0
            return
        }
        
        if let index = availableAudioFiles.firstIndex(of: savedAudioFile) {
            selectedSoundIndex = index
        } else {
            selectedSoundIndex = 0
            saveSelection()
        }
    }
    
    func selectSound(at index: Int) {
        guard index < availableAudioFiles.count else { return }
        
        selectedSoundIndex = index
        playSound(at: index)
    }
    
    private func playSound(at index: Int) {
        guard index < availableAudioFiles.count else { return }
        
        let audioFile = availableAudioFiles[index]
        audioManager.playAudio(audioFile: audioFile)
    }
    
    func saveSelection() {
        guard selectedSoundIndex < availableAudioFiles.count else { return }
        
        let currentPetType = petStorage.getPetType()
        let selectedAudioFile = availableAudioFiles[selectedSoundIndex]
        
        petStorage.setSelectedAudioFileName(selectedAudioFile.rawValue, for: currentPetType)
        navigationManager.popToRoot()
    }
    
    func stopCurrentAudio() {
        audioManager.stopAudio()
    }
    
    func getCurrentSelectedAudioFile() -> AudioFile? {
        guard selectedSoundIndex < availableAudioFiles.count else { return nil }
        return availableAudioFiles[selectedSoundIndex]
    }
}
