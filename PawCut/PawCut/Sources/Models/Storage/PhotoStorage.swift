//
//  PhotoStorage.swift
//  PawCut
//
//  Created by taeni on 9/23/25.
//

import Foundation
import SwiftData

final class PhotoStorage: PhotoStorageManaging {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getAllPhotos() -> [Photo] {
        let descriptor = FetchDescriptor<Photo>(
            sortBy: [SortDescriptor(\.createdAt, order: .forward)]
        )
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("사진 조회 실패: \(error)")
            return []
        }
    }
    
    func getPhotos(for date: Date) -> [Photo] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? date
        
        let predicate = #Predicate<Photo> { photo in
            photo.createdAt >= startOfDay && photo.createdAt < endOfDay
        }
        
        let descriptor = FetchDescriptor<Photo>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.createdAt, order: .forward)]
        )
        
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("날짜별 사진 조회 실패: \(error)")
            return []
        }
    }
    
    // loadPhotos
    func getGroupedPhotos() -> [Date: [Photo]] {
        let photos = getAllPhotos()
        let calendar = Calendar.current
        
        return Dictionary(grouping: photos) { photo in
            calendar.startOfDay(for: photo.createdAt)
        }
    }
    
    func savePhoto(_ photo: Photo) {
        modelContext.insert(photo)
        do {
            try modelContext.save()
        } catch {
            print("사진 저장 실패: \(error)")
        }
    }
    
    func deletePhoto(_ photo: Photo) {
        modelContext.delete(photo)
        do {
            try modelContext.save()
        } catch {
            print("사진 삭제 실패 \(error)")
        }
    }
    
    func getPhotosCount() -> Int {
        return getAllPhotos().count
    }
    
    func getOldestPhotoDate() -> Date? {
        let descriptor = FetchDescriptor<Photo>(
            sortBy: [SortDescriptor(\.createdAt, order: .forward)]
        )
        do {
            let photos = try modelContext.fetch(descriptor)
            return photos.first?.createdAt
        } catch {
            print("가장 오래된 사진 날짜 조회 실패 \(error)")
            return nil
        }
    }
}
