//
//  UINavigationController+SwipeBack.swift
//  PawCut
//
//  Created by Luminouxx on 10/28/25.
//

import UIKit
import SwiftUI

private class SwipeBackGestureDelegate: NSObject, UIGestureRecognizerDelegate {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let navController = navigationController else { return false }
        return navController.viewControllers.count > 1
    }
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return false
    }
}

struct EnableSwipeBackModifier: ViewModifier {
    let isEnabled: Bool
    
    func body(content: Content) -> some View {
        content
            .background(
                NavigationControllerAccessor(isSwipeBackEnabled: isEnabled)
            )
    }
}

struct NavigationControllerAccessor: UIViewControllerRepresentable {
    let isSwipeBackEnabled: Bool
    
    func makeUIViewController(context: Context) -> NavigationControllerAccessorViewController {
        NavigationControllerAccessorViewController(isSwipeBackEnabled: isSwipeBackEnabled)
    }
    
    func updateUIViewController(_ uiViewController: NavigationControllerAccessorViewController, context: Context) {
        uiViewController.updateSwipeBackState(isEnabled: isSwipeBackEnabled)
    }
}

class NavigationControllerAccessorViewController: UIViewController {
    private var isSwipeBackEnabled: Bool
    private var gestureDelegate: SwipeBackGestureDelegate?
    
    init(isSwipeBackEnabled: Bool) {
        self.isSwipeBackEnabled = isSwipeBackEnabled
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("NavigationControllerAccessorViewController: init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isHidden = true
        view.isUserInteractionEnabled = false
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        updateSwipeBackState(isEnabled: isSwipeBackEnabled)
    }
    
    func updateSwipeBackState(isEnabled: Bool) {
        self.isSwipeBackEnabled = isEnabled
        
        guard let navigationController = navigationController else { return }
        
        if isEnabled {
            if gestureDelegate == nil {
                gestureDelegate = SwipeBackGestureDelegate(navigationController: navigationController)
            }
            
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
            navigationController.interactivePopGestureRecognizer?.delegate = gestureDelegate
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
            navigationController.interactivePopGestureRecognizer?.delegate = nil
        }
    }
    
    deinit {
        if let navController = navigationController {
            navController.interactivePopGestureRecognizer?.delegate = nil
        }
        gestureDelegate = nil
    }
}

extension View {
    func enableNativeSwipeBack(_ isEnabled: Bool = true) -> some View {
        modifier(EnableSwipeBackModifier(isEnabled: isEnabled))
    }
}
