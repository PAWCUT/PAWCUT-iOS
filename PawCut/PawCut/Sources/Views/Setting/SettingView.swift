//
//  SettingView.swift
//  PawCut
//
//  Created by donghee on 8/19/25.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var viewModel = SettingViewModel()
    
    var body: some View {
        VStack(spacing: 8) {
            Group {
                PawSettingRow(title: "프로필 수정") {
                    viewModel.navigateToProfileEdit()
                }
                PawSettingRow(title: "소리 수정") {
                    viewModel.navigateToSoundEdit()
                }
            }
            
            PawSectionSeparator()
            
            Group {
                PawSettingRow(title: "1 : 1 문의") {
                    viewModel.requestCustomerInquiry()
                }
                PawSettingRow(title: "서비스 이용 약관") {
                    viewModel.navigateToServiceTerms()
                }
            }
            
            Spacer()
        }
        .padding(.top, 8)
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(
            item: Binding<URLItem?>(
                get: {
                    viewModel.customerInquiryURL.map { URLItem(url: $0) }
                },
                set: { _ in
                    viewModel.customerInquiryURL = nil
                }
            )
        ) { urlItem in
            SFSafariViewControllerWrapper(url: urlItem.url)
        }
    }
}

#Preview {
    SettingView()
}
