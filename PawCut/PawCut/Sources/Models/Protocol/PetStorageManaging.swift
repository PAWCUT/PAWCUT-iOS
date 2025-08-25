//
//  PetStorageManaging.swift
//  PawCut
//
//  Created by Luminouxx on 8/21/25.
//

import Foundation

protocol PetStorageManaging {
    
    func getPetName() -> String
    
    func setPetName(_ name: String)
    
    func getPetType() -> PetType
    
    func setPetType(_ type: PetType)
    
    func getSelectedAudioFileName(for petType: PetType) -> String?
    
    func setSelectedAudioFileName(_ fileName: String, for petType: PetType)
}
