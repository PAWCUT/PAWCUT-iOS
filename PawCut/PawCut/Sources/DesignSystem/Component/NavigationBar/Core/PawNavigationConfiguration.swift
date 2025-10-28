//
//  PawNavigationConfiguration.swift
//  PawCut
//
//  Created by Luminouxx on 10/26/25.
//

import SwiftUI

struct PawNavigationConfiguration {
    var style: PawNavigationStyle
    var title: String
    var backAction: (() -> Void)?
    var trailingItem: AnyView?
    var isHidden: Bool

    
    init(
        style: PawNavigationStyle = .onlyBackButton,
        title: String = "",
        backAction: (() -> Void)? = nil,
        trailingItem: AnyView? = nil,
        isHidden: Bool = false
    ) {
        self.style = style
        self.title = title
        self.backAction = backAction
        self.trailingItem = trailingItem
        self.isHidden = isHidden
    }
}

struct PawNavigationConfigurationKey: EnvironmentKey {
    static let defaultValue = PawNavigationConfiguration()
}

extension EnvironmentValues {
    var pawNavigationConfiguration: PawNavigationConfiguration {
        get { self[PawNavigationConfigurationKey.self] }
        set { self[PawNavigationConfigurationKey.self] = newValue }
    }
}
