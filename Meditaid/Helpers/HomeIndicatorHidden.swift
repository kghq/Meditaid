//
//  HomeIndicatorHidden.swift
//  Meditaid
//
//  Created by Krzysztof Garmulewicz on 01/12/2025.
//

import SwiftUI

class HomeIndicatorHostingController<Content: View>: UIHostingController<Content> {
    var isHidden: Bool = false {
        didSet {
            setNeedsUpdateOfHomeIndicatorAutoHidden()
        }
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        isHidden
    }
}

struct HomeIndicatorAutoHiddenWrapper<Content: View>: UIViewControllerRepresentable {
    var content: Content
    var isHidden: Bool

    func makeUIViewController(context: Context) -> HomeIndicatorHostingController<Content> {
        let controller = HomeIndicatorHostingController(rootView: content)
        controller.isHidden = isHidden
        return controller
    }

    func updateUIViewController(_ uiViewController: HomeIndicatorHostingController<Content>, context: Context) {
        uiViewController.rootView = content
        uiViewController.isHidden = isHidden
    }
}

extension View {
    func autoHideHomeIndicator(_ hide: Bool) -> some View {
        HomeIndicatorAutoHiddenWrapper(content: self, isHidden: hide)
    }
}
