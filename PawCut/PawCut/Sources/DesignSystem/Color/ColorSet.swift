//
//  ColorSet.swift
//  PawCut
//
//  Created by 광로 on 7/17/25.
//

import SwiftUI

enum ColorSet {
    enum GrayScale: String, CaseIterable {
        case grayScale01 = "GrayScale01Color"
        case grayScale02 = "GrayScale02Color"
        case grayScale03 = "GrayScale03Color"
        case grayScale04 = "GrayScale04Color"
        case grayScale05 = "GrayScale05Color"
        case grayScale06 = "GrayScale06Color"
    }
    
    enum PointPurple: String, CaseIterable {
        case pointPurple01 = "PointPurple01Color"
        case pointPurple02 = "PointPurple02Color"
    }
    
    enum PointRed: String, CaseIterable {
        case pointRed01 = "PointRed01Color"
        case pointRed02 = "PointRed02Color"
    }
} 
