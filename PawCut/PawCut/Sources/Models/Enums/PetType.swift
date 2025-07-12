//
//  PetType.swift
//  pawCut
//
//  Created by taeni on 5/31/25.
//
import Foundation

enum PetType: String, CaseIterable, Codable {
    case dog = "강아지"
    case cat = "고양이"
    
    var filePrefix: String {
        switch self {
        case .dog: return "dog_"
        case .cat: return "cat_"
        }
    }
}
