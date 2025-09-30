//
//  PetTypeSelectionView.swift
//  PawCut
//
//  Created by donghee on 8/13/25.
//

import SwiftUI

struct PetTypeSelectionView: View {
    @Binding var isDogEnabled: Bool
    @Binding var isCatEnabled: Bool

    let didSelectDog: () -> Void
    let didSelectCat: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            PawChoiceButton(
                "강아지",
                isEnabled: isDogEnabled,
                horizontalPadding: 0,
                verticalPadding: 0
            ) {
                didSelectDog()
            }

            PawChoiceButton(
                "고양이",
                isEnabled: isCatEnabled,
                horizontalPadding: 0,
                verticalPadding: 0
            ) {
                didSelectCat()
            }
        }
    }
}

#Preview {
    @Previewable @State var isDogEnabled = false
    @Previewable @State var isCatEnabled = true

    PetTypeSelectionView(
        isDogEnabled: $isDogEnabled,
        isCatEnabled: $isCatEnabled,
        didSelectDog: { isDogEnabled.toggle() },
        didSelectCat: { isCatEnabled.toggle() }
    )
}
