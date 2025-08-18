//
//  Photo+.swift
//  PawCut
//
//  Created by taeni on 8/13/25.
//

import Foundation

// MARK: mock 데이터
extension Photo {
    static var mockPhotos: [Photo] {
        let calendar = Calendar.current
        var photos: [Photo] = []
        
        // Create photos for today
        let today = Date()
        for i in 0..<6 {
            let photo = Photo(fileName: "today_photo_\(i).jpg")
            photo.createdAt = calendar.date(byAdding: .minute, value: i * 45, to: today) ?? today
            photos.append(photo)
        }
        
        // Create photos for yesterday
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        for i in 0..<4 {
            let photo = Photo(fileName: "yesterday_photo_\(i).jpg")
            photo.createdAt = calendar.date(byAdding: .hour, value: i * 2, to: yesterday) ?? yesterday
            photos.append(photo)
        }
        
        // Create photos for 3 days ago
        let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: today) ?? today
        for i in 0..<5 {
            let photo = Photo(fileName: "threeDaysAgo_photo_\(i).jpg")
            photo.createdAt = calendar.date(byAdding: .hour, value: i * 3, to: threeDaysAgo) ?? threeDaysAgo
            photos.append(photo)
        }
        
        
        // Create photos for 4 days ago
        let fourDaysAgo = calendar.date(byAdding: .day, value: -4, to: today) ?? today
        for i in 0..<7 {
            let photo = Photo(fileName: "fourDaysAgo_photo_\(i).jpg")
            photo.createdAt = calendar.date(byAdding: .hour, value: i * 3, to: fourDaysAgo) ?? fourDaysAgo
            photos.append(photo)
        }
        
        return photos
    }
    
    static var mockGroupedPhotos: [Date: [Photo]] {
        let calendar = Calendar.current
        return Dictionary(grouping: Photo.mockPhotos) { photo in
            calendar.startOfDay(for: photo.createdAt)
        }
    }
}
