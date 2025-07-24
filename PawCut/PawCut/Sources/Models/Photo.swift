//
//  Photo.swift
//  PawCut
//
//  Created by taeni on 7/25/25.
//

import Foundation
import SwiftData

@Model
class Photo : Identifiable{
    var id: UUID
    var fileName: String
    var createdAt: Date = Date.now
    
    init(fileName: String) {
        self.id = UUID()
        self.fileName = fileName
        self.createdAt = Date()
    }
}
