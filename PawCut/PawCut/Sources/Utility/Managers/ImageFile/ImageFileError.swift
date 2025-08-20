//
//  ImageFileError.swift
//  PawCut
//
//  Created by taeni on 8/19/25.
//

import Foundation

enum ImageFileError: LocalizedError {
    case imageConversionFailed
    case fileNotFound(String)
    case saveToSandboxFailed
    case deleteFileFailed
    case photoLibraryAccessDenied
    case invalidFileName
    
    var errorDescription: String? {
        switch self {
        case .imageConversionFailed:
            return "이미지를 JPEG로 변환할 수 없습니다"
        case .fileNotFound(let fileName):
            return "파일을 찾을 수 없습니다: \(fileName)"
        case .saveToSandboxFailed:
            return "샌드박스에 파일 저장 실패"
        case .deleteFileFailed:
            return "파일 삭제 실패"
        case .photoLibraryAccessDenied:
            return "사진 앱 접근 권한이 필요합니다"
        case .invalidFileName:
            return "유효하지 않은 파일명입니다"
        }
    }
}
