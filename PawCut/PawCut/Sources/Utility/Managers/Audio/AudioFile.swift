//
//  AudioFile.swift
//  PawCut
//
//  Created by Luminouxx on 8/22/25.
//

import Foundation

enum AudioFile: String, CaseIterable {
    case dogDoorlock = "dog_doorlock"
    case dogBark = "dog_bark"
    case dogToy = "dog_toy"
    case dogDoorbell = "dog_doorbell"
    case dogFrequencyMulti = "dog_frequency_multi"
    
    case catMeow = "cat_meow"
    case catKittenMeow = "cat_kitten_meow"
    
    case plasticBag = "common_plastic_bag"
    case frequency16000 = "common_frequency_16000"
    case frequency8000 = "common_frequency_8000"
    
    
    var displayName: String {
        switch self {
        case .dogDoorlock: return "강아지 도어락"
        case .dogBark: return "강아지 멍멍"
        case .dogToy: return "강아지 장난감"
        case .dogDoorbell: return "강아지 종소리(문)"
        case .dogFrequencyMulti: return "강아지 주파수(다중)"
        case .catMeow: return "고양이 야옹"
        case .catKittenMeow: return "고양이 야옹(새끼)"
        case .plasticBag: return "공통 비닐봉지"
        case .frequency16000: return "공통 주파수(16000)"
        case .frequency8000: return "공통 주파수(8000)"
        }
    }
    
    var category: AudioCategory {
        switch self {
        case .dogDoorlock, .dogBark, .dogToy, .dogDoorbell, .dogFrequencyMulti:
            return .dog
        case .catMeow, .catKittenMeow:
            return .cat
        case .plasticBag, .frequency16000, .frequency8000:
            return .common
        }
    }
    
    static func availableFiles(for petType: PetType) -> [AudioFile] {
        let commonFiles = AudioFile.allCases.filter { $0.category == .common }
        
        switch petType {
        case .dog:
            let dogFiles = AudioFile.allCases.filter { $0.category == .dog }
            return dogFiles + commonFiles
        case .cat:
            let catFiles = AudioFile.allCases.filter { $0.category == .cat }
            return catFiles + commonFiles
        }
    }
    
    enum AudioCategory {
        case dog
        case cat
        case common
    }
}
