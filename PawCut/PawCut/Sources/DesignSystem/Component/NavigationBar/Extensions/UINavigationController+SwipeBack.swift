//
//  UINavigationController+SwipeBack.swift
//  PawCut
//
//  Created by Luminouxx on 10/28/25.
//

import UIKit
import SwiftUI

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
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
    
    init(isSwipeBackEnabled: Bool) {
        self.isSwipeBackEnabled = isSwipeBackEnabled
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("NavigationControllerAccessorViewController : init(coder:) has not been implemented")
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        updateSwipeBackState(isEnabled: isSwipeBackEnabled)
    }
    
    func updateSwipeBackState(isEnabled: Bool) {
        self.isSwipeBackEnabled = isEnabled
        
        guard let navigationController = navigationController else { return }
        
        if isEnabled {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
            navigationController.interactivePopGestureRecognizer?.delegate = navigationController as? UIGestureRecognizerDelegate
        } else {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}

extension View {
    func enableNativeSwipeBack(_ isEnabled: Bool = true) -> some View {
        modifier(EnableSwipeBackModifier(isEnabled: isEnabled))
    }
}
