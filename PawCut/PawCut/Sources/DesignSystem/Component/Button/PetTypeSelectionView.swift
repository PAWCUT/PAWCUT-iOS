//
//  PetTypeSelectionView.swift
//  PawCut
//
//  Created by donghee on 8/13/25.
//

import SwiftUI

@MainActor protocol PetTypeSelectable: ObservableObject {
    var isDogEnabled: Bool { get }
    var isCatEnabled: Bool { get }

    func didSelectDog()
    func didSelectCat()
}

struct PetTypeSelectionView<ViewModel: PetTypeSelectable>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        HStack(spacing: 12) {
            PawChoiceButton(
                "강아지",
                isEnabled: viewModel.isDogEnabled,
                horizontalPadding: 0,
                verticalPadding: 0
            ) {
                viewModel.didSelectDog()
            }

            PawChoiceButton(
                "고양이",
                isEnabled: viewModel.isCatEnabled,
                horizontalPadding: 0,
                verticalPadding: 0
            ) {
                viewModel.didSelectCat()
            }
        }
    }
}

#Preview {
    PetTypeSelectionView(viewModel: PetInfoViewModel())
}
