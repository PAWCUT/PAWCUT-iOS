//
//  ImageFileManager.swift
//  PawCut
//
//  Created by taeni on 8/19/25.
//

import SwiftUI
import Photos

@Observable
@MainActor
final class ImageFileManager {
    
    static let shared = ImageFileManager()
    
    private let documentsDirectory: URL
    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    
    private let compressionQuality: CGFloat = ImageQuality.originally.compressionValue
    
    private let supportedExtensions: Set<String> = ["jpg", "jpeg", "png"]
    
    private init() {
        self.documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        configureCache()
    }
    
    private func configureCache() {
        cache.countLimit = 50 // 최대 50개 이미지 캐시
        cache.totalCostLimit = 100 * 1024 * 1024 // 100MB 제한
    }
}

extension ImageFileManager {
    
    // 샌드박스에 저장
    func saveImage(
        _ image: UIImage,
        fileName: String? = nil
    ) async throws -> String {
        let finalFileName = fileName ?? generateFileName()
        
        guard isValidFileName(finalFileName) else {
            throw ImageFileError.invalidFileName
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(finalFileName)
        
        // JPEG 데이터 변환
        guard let imageData = image.jpegData(compressionQuality: compressionQuality ) else {
            throw ImageFileError.imageConversionFailed
        }
        
        // 파일 저장
        do {
            try imageData.write(to: fileURL)
            cache.setObject(image, forKey: finalFileName as NSString)
            return finalFileName
        } catch {
            throw ImageFileError.saveToSandboxFailed
        }
    }
    
    // 파일명으로 이미지 로드 (async)
    func loadImage(fileName: String) async -> UIImage? {
        // 캐시 확인
        if let cachedImage = cache.object(forKey: fileName as NSString) {
            return cachedImage
        }
        
        // 파일에서 로드
        return await withCheckedContinuation { continuation in
            Task.detached {
                let fileURL = self.documentsDirectory.appendingPathComponent(fileName)
                
                guard let imageData = try? Data(contentsOf: fileURL),
                      let image = UIImage(data: imageData) else {
                    await MainActor.run {
                        continuation.resume(returning: nil)
                    }
                    return
                }
                
                await MainActor.run {
                    self.cache.setObject(image, forKey: fileName as NSString)
                    continuation.resume(returning: image)
                }
            }
        }
    }
    
    // 여러 이미지 동시 로드
    func loadImages(fileNames: [String]) async -> [String: UIImage] {
        await withTaskGroup(of: (String, UIImage?).self) { group in
            var results: [String: UIImage] = [:]
            
            for fileName in fileNames {
                group.addTask {
                    let image = await self.loadImage(fileName: fileName)
                    return (fileName, image)
                }
            }
            
            for await (fileName, image) in group {
                if let image = image {
                    results[fileName] = image
                }
            }
            
            return results
        }
    }
    
    // 파일 삭제
    func deleteFile(fileName: String) async throws {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        // 파일 삭제
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(at: fileURL)
                cache.removeObject(forKey: fileName as NSString)
            } catch {
                throw ImageFileError.deleteFileFailed
            }
        }
    }
}

extension ImageFileManager {
    
    // 파일명 목록 반환
    func getAllImageFileNames() throws -> [String] {
        let fileURLs = try fileManager.contentsOfDirectory(
            at: documentsDirectory,
            includingPropertiesForKeys: [.creationDateKey],
            options: []
        ).filter { url in
            supportedExtensions.contains(url.pathExtension.lowercased())
        }.sorted { url1, url2 in
            let date1 = (try? url1.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast
            let date2 = (try? url2.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast
            return date1 > date2
        }
        
        return fileURLs.map { $0.lastPathComponent }
    }
    
    // 썸네일 생성 (원본 이미지의 비율 조정)
    func generateThumbnail(
        from image: UIImage,
        scaleFactor: CGFloat = 0.5,  // 절반의 크기
        quality: ImageQuality = .thumbnail
    ) -> UIImage? {
        let originalSize = image.size
        let thumbnailSize = CGSize(
            width: originalSize.width * scaleFactor,
            height: originalSize.height * scaleFactor
        )
        
        let renderer = UIGraphicsImageRenderer(size: thumbnailSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: thumbnailSize))
        }
    }
}

extension ImageFileManager {
    
    // 이미지 사진앱 저장
    func saveToPhotoLibrary(image: UIImage) async throws {
        let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        
        guard status == .authorized || status == .limited else {
            throw ImageFileError.photoLibraryAccessDenied
        }
        
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }
    }
}

extension ImageFileManager {
    
    // 모든 이미지 파일 개수 반환
    var imageFileCount: Int {
        do {
            let fileURLs = try fileManager.contentsOfDirectory(
                at: documentsDirectory,
                includingPropertiesForKeys: nil
            )
            return fileURLs.filter { url in
                supportedExtensions.contains(url.pathExtension.lowercased())
            }.count
        } catch {
            return 0
        }
    }
    
    // 가장 오래된 이미지의 생성 날짜 반환(캘린더의 최소 달)
    func getOldestImageDate() async -> Date? {
        do {
            let fileURLs = try fileManager.contentsOfDirectory(
                at: documentsDirectory,
                includingPropertiesForKeys: [.creationDateKey],
                options: []
            ).filter { url in
                supportedExtensions.contains(url.pathExtension.lowercased())
            }
            
            var oldestDate: Date?
            
            for fileURL in fileURLs {
                if let creationDate = try? fileURL.resourceValues(forKeys: [.creationDateKey]).creationDate {
                    if oldestDate == nil || creationDate < oldestDate! {
                        oldestDate = creationDate
                    }
                }
            }
            
            return oldestDate
        } catch {
            print("오래된 이미지 날짜 조회 실패: \(error)")
            return nil
        }
    }
    
    // 파일 존재 여부 확인
    func fileExists(fileName: String) -> Bool {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        return fileManager.fileExists(atPath: fileURL.path)
    }
    
    // 파일 URL 반환
    func fileURL(for fileName: String) -> URL {
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    // 파일명 생성
    private func generateFileName() -> String {
        let timestamp = Int(Date().timeIntervalSince1970)
        let uuid = UUID().uuidString.prefix(8)
        return "image_\(timestamp)_\(uuid).jpg"
    }
    
    // 파일명 유효성 검사
    private func isValidFileName(_ fileName: String) -> Bool {
        let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "._-"))
        return fileName.rangeOfCharacter(from: allowedCharacters.inverted) == nil
    }
    
    // 캐시 정리
    func clearCache() {
        cache.removeAllObjects()
    }
    
    // 모든 이미지 파일 삭제 (주의: 복구 불가능)
    func deleteAllImages() async throws {
        do {
            let fileURLs = try fileManager.contentsOfDirectory(
                at: documentsDirectory,
                includingPropertiesForKeys: nil
            )
            
            for fileURL in fileURLs {
                if supportedExtensions.contains(fileURL.pathExtension.lowercased()) {
                    try fileManager.removeItem(at: fileURL)
                    cache.removeObject(forKey: fileURL.lastPathComponent as NSString)
                }
            }
            
            // TODO: 경로가 저장된 Photo DB도 삭제하는 로직 필요
            // modelContext.delete() ... save()...
            
        } catch {
            throw ImageFileError.deleteFileFailed
        }
    }
}
