//
//  PhotoStorageManaging.swift
//  PawCut
//
//  Created by taeni on 9/23/25.
//

import Foundation

protocol PhotoStorageManaging {
    
    func getAllPhotos() async throws -> [Photo]
    
    func getPhotos(for date: Date) async throws -> [Photo]
    
    func getGroupedPhotos() async throws -> [Date: [Photo]]
    
    func savePhoto(_ photo: Photo) async throws
    
    func deletePhoto(_ photo: Photo) async throws
    
    func getPhotosCount() async throws -> Int
    // calendar 구현을 위해 필요
    func getOldestPhotoDate() async throws -> Date?
}
