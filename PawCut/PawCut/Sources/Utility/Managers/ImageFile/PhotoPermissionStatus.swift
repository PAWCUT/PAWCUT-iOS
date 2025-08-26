//
//  PhotoPermissionStatus.swift
//  PawCut
//
//  Created by taeni on 8/26/25.
//

import Photos

enum PhotoPermissionStatus {
    case authorized
    case limited
    case denied
    case notDetermined
    case restricted
    case unknown
    
    init(from authStatus: PHAuthorizationStatus) {
        switch authStatus {
        case .authorized:
            self = .authorized
        case .limited:
            self = .limited
        case .denied:
            self = .denied
        case .notDetermined:
            self = .notDetermined
        case .restricted:
            self = .restricted
        @unknown default:
            self = .unknown
        }
    }
    
    var canSavePhoto: Bool {
        switch self {
        case .authorized, .limited:
            return true
        case .denied, .notDetermined, .restricted, .unknown:
            return false
        }
    }
    
    var userMessage: String {
        switch self {
        case .authorized, .limited:
            return ""
        case .denied:
            return "사진 접근 권한이 필요해요. 설정에서 허용해주세요."
        case .notDetermined:
            return "사진 접근 권한을 허용해주세요."
        case .restricted:
            return "사진 접근이 제한되어 있어요."
        case .unknown:
            return "권한 상태를 알 수 없어요."
        }
    }
}
