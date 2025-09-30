//
//  OnboardingView.swift
//  PawCut
//
//  Created by donghee on 8/16/25.
//

import SwiftUI

struct OnboardingPageContent {
    let title: String
    let description: String
    let imageName: String
    let imageSize: CGSize
}

struct OnboardingContentView: View {
    let content: OnboardingPageContent

    var body: some View {
        VStack {
            Spacer()

            PawTitleLabel
                .bold24(
                    content.title,
                    alignment: .center,
                    lineLimit: 2
                )
                .padding(12)

            PawBodyLabel
                .med16(
                    content.description,
                    color: .grayScale03,
                    alignment: .center,
                    lineLimit: 2
                )

            Spacer()

            ImageComponent(
                imageName: content.imageName,
                size: content.imageSize
            )

            Spacer()
        }
    }
}

struct OnboardingView: View {

    @StateObject private var viewModel = OnboardingViewModel()

    private let onboardingPages = [
        OnboardingPageContent(
            title: "귀가 쫑긋! \n그 찰나를 담아보세요",
            description: "우리 아이가 반응하는 소리로\n자연스러운 시선을 끌어내보세요",
            imageName: "onboarding_1",
            imageSize: CGSize(width: 220, height: 251)
        ),
        OnboardingPageContent(
            title: "특별한 날에는,\n포우-컷으로 남겨보세요",
            description: "함께하는 소중한 하루를\n오래도록 간직할 수 있어요",
            imageName: "onboarding_2",
            imageSize: CGSize(width: 180, height: 258)
        ),
        OnboardingPageContent(
            title: "사진은 언제나\n다시 꺼내볼 수 있어요",
            description: "언제든 꺼내볼 수 있는\n따뜻한 기록이 되어줄 거예요",
            imageName: "onboarding_3",
            imageSize: CGSize(width: 200, height: 265)
        )
    ]

    var body: some View {
        VStack {
            TabView(selection: $viewModel.currentPage) {
                ForEach(0..<onboardingPages.count, id: \.self) { index in
                    OnboardingContentView(content: onboardingPages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            PageControl(
                numberOfPages: onboardingPages.count,
                currentPage: viewModel.currentPage
            )
            .animation(.easeInOut(duration: 0.3), value: viewModel.currentPage)
            .padding(.bottom, 20)

            PawPrimaryButton("다음") {
                viewModel.tapNextButton()
            }
        }
    }
}

#Preview {
    OnboardingView()
}