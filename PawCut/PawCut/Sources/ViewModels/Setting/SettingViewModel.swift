//
//  SettingViewModel.swift
//  PawCut
//
//  Created by donghee on 8/19/25.
//

import Foundation
import SafariServices
import UIKit

@MainActor
class SettingViewModel: ObservableObject {
    private let navigationManager = NavigationManager.shared
    @Published var customerInquiryURL: URL?

    func navigateToProfileEdit() {
        navigationManager.navigate(to: .main(.fixPetInfo))
    }

    func navigateToSoundEdit() {
        navigationManager.navigate(to: .main(.soundSetting))
    }

    func requestCustomerInquiry() {
        customerInquiryURL = URL(string: "https://open.kakao.com/o/s4Za1sNh")
    }

    func navigateToServiceTerms() {
        navigationManager.navigate(to: .main(.terms))
    }
}
