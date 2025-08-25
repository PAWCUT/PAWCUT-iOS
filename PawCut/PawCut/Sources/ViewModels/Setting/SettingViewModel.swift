//
//  SettingViewModel.swift
//  PawCut
//
//  Created by donghee on 8/19/25.
//

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
        customerInquiryURL = URL(string: "https://posacademy.notion.site/2552b843d5af8049ba23cd11aa0051c6?source=copy_link")
    }
}
