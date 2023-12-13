//
//  View+sensitiveOverlay.swift
//  NukeSensitivity
//
//  Created by Sam Spencer on 12/11/23.
//  Copyright © 2023 nenos, Inc. All rights reserved.
//

import NukeUI
import SensitiveContentAnalysis
import SwiftUI

public extension View {
    
    /// Adds a responsive Sensitve Content overlay if the loaded image content is
    /// sensitive _and_ the user has enabled Sensitive Content Analysis on their device
    /// for this app.
    ///
    /// Overlays and obfuscates sensitive content in the manner described by Apple in
    /// the [Detecting nudity in media and providing intervention options](https://developer.apple.com/documentation/sensitivecontentanalysis/detecting-nudity-in-media-and-providing-intervention-options)
    /// document. If the user (or, in the case of children, the parent / guardian) has
    /// opted in to Sensitive Content warnings, this modifier will intercept and blur
    /// any content that the system framework flags as sensitive. You will need to
    /// perform additional setup in your application to properly use this modifier.
    ///
    /// - important: This modifier must be used directly with the `SwiftUI.Image` returned
    ///   from NukeUI's content sensitivity `LazyImage` initializers, either:
    ///   ``NukeUI/LazyImage/init(url:sensitiveContentShim:)`` or
    ///   ``NukeUI/LazyImage/init(url:transaction:sensitiveContentShim:content:)``.
    ///
    /// - parameter viewModel: A ``SensitiveContentShim`` instance.
    /// - parameter overlayTitle: The user-facing label displayed over sensitive
    ///   content. Defaults to "This image may be sensitive."
    /// - parameter clipShape: The `SwiftUI.Shape` used to clip the content overlay.
    /// - parameter actionButtons: _Optional_. If provided, a context menu will appear
    ///   in the top-trailing corner of the sensitive overlay with the given buttons.
    ///
    /// - seealso: NukeUI's `LazyImage` initializers for sensitive content detection,
    /// ``NukeUI/LazyImage/init(url:sensitiveContentShim:)``, and the required View
    ///   Model to manage it, ``SensitiveContentShim``.
    ///
    func sensitiveOverlay<S: Shape, MenuButtons: View>(
        viewModel: SensitiveContentShim,
        overlayTitle: LocalizedStringKey = "This image may be sensitive.",
        clipShape: S = Rectangle(),
        actionButtons: @escaping (() -> MenuButtons) = { EmptyView() }
    ) -> some View {
        SensitiveImageOverlay(
            viewModel: viewModel,
            overlayTitle: overlayTitle,
            clipShape: clipShape,
            content: {
                self
            },
            actionButtons: actionButtons
        )
    }
    
}
