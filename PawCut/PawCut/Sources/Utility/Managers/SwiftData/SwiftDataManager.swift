//
//  SwiftDataManager.swift
//  PawCut
//
//  Created by Claude on 8/25/25.
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataManager: ObservableObject {
    static let shared = SwiftDataManager()
    
    private let container: ModelContainer
    private var context: ModelContext {
        container.mainContext
    }
    
    private init() {
        let schema = Schema([
            Photo.self
        ])
        
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            container = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("SwiftData ModelContainer 초기화 실패: \(error)")
        }
    }
    
    // MARK: - Container Access
    var modelContainer: ModelContainer {
        return container
    }
    
    var modelContext: ModelContext {
        return context
    }
    
    // MARK: - CRUD Operations
    
    /// 데이터 저장
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    /// Photo 저장
    func savePhoto(fileName: String) throws {
        let photo = Photo(fileName: fileName)
        context.insert(photo)
        try save()
    }
    
    /// Photo 삭제
    func deletePhoto(_ photo: Photo) throws {
        context.delete(photo)
        try save()
    }
    
    /// 모든 Photo 조회 (최신순)
    func fetchAllPhotos() throws -> [Photo] {
        let descriptor = FetchDescriptor<Photo>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }
    
    /// 날짜별 Photo 조회
    func fetchPhotos(for date: Date) throws -> [Photo] {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = #Predicate<Photo> { photo in
            photo.createdAt >= startOfDay && photo.createdAt < endOfDay
        }
        
        let descriptor = FetchDescriptor<Photo>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        return try context.fetch(descriptor)
    }
    
    /// 날짜 범위별 Photo 조회
    func fetchPhotos(from startDate: Date, to endDate: Date) throws -> [Photo] {
        let predicate = #Predicate<Photo> { photo in
            photo.createdAt >= startDate && photo.createdAt <= endDate
        }
        
        let descriptor = FetchDescriptor<Photo>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        return try context.fetch(descriptor)
    }
    
    /// 날짜별로 그룹화된 Photo 조회
    func fetchGroupedPhotos() throws -> [Date: [Photo]] {
        let allPhotos = try fetchAllPhotos()
        let calendar = Calendar.current
        
        var groupedPhotos: [Date: [Photo]] = [:]
        
        for photo in allPhotos {
            let dayKey = calendar.startOfDay(for: photo.createdAt)
            
            if groupedPhotos[dayKey] == nil {
                groupedPhotos[dayKey] = []
            }
            groupedPhotos[dayKey]?.append(photo)
        }
        
        return groupedPhotos
    }
    
    /// Photo 개수 조회
    func getPhotoCount() throws -> Int {
        let descriptor = FetchDescriptor<Photo>()
        return try context.fetchCount(descriptor)
    }
    
    /// 특정 날짜의 Photo 개수 조회
    func getPhotoCount(for date: Date) throws -> Int {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = #Predicate<Photo> { photo in
            photo.createdAt >= startOfDay && photo.createdAt < endOfDay
        }
        
        let descriptor = FetchDescriptor<Photo>(predicate: predicate)
        return try context.fetchCount(descriptor)
    }
}
