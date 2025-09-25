//
//  FrameType.swift
//  PawCut
//
//  Created by Jay on 9/24/25.
//

import Foundation

enum FrameType: String, CaseIterable {
    case snow, ink, cobalt, peek, heart, cloud, blush, wave, sparkle, dawn,
        bloom, breeze, blue, ginkgo
    
    var frameScrollImageName: String {"\(rawValue)_scroll"}
    
    var frameImageName: String {"\(rawValue)_frame"}
    
    var displayName: String {rawValue.prefix(1).uppercased() + rawValue.dropFirst()}
}
