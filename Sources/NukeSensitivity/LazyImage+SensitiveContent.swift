//
//  LazyImage+SensitiveContent.swift
//  NukeSensitivity
//
//  Created by Sam Spencer on 12/11/23.
//  Copyright © 2023 nenos, Inc. All rights reserved.
//

import Foundation
import NukeUI
import SwiftUI

@MainActor public extension LazyImage {
    
    /// Loads and displays an image using `SwiftUI.Image`, and attempts to check for
    /// sensitive content using the Sensitive Content Analysis framework (if enabled).
    ///
    /// - parameter url: The image URL.
    /// - parameter sensitiveContentShim: The ``SensitiveContentShim`` view model that
    ///   will perform content analysis and emit results to observers.
    ///
    init(url: URL?, sensitiveContentShim: SensitiveContentShim) where Content == Image {
        self.init(request: url.map { ImageRequest(url: $0) })
    }
    
    /// Loads an images and displays custom content for each state, and attempts to
    /// check for sensitive content using the Sensitive Content Analysis framework (if
    /// enabled).
    ///
    /// - parameter url: The image URL.
    /// - parameter sensitiveContentShim: The ``SensitiveContentShim`` view model that
    ///   will perform content analysis and emit results to observers.
    /// - parameter content: The view to show for each of the image loading states.
    ///
    /// The easiest way to dynamically detect sensitive content and obfuscate it, as
    /// needed, is to pass in a ``SensitiveContentShim`` to which you maintain a
    /// reference. Append the
    /// ``SwiftUI/View/sensitiveOverlay(viewModel:overlayTitle:clipShape:actionButtons:)``
    /// modifier to the returned image. Although the modifier acts on a loaded image,
    /// this is in-line with Apple's recommendation to load content regardless of
    /// sensitivity, and handle the obfuscation as part of the presentation. If the user
    /// has opted-in and the content is sensitive, the user will **not** be shown any
    /// sensitive content unless they explicitly choose to.
    ///
    /// ```swift
    /// LazyImage(url: yourURL, sensitiveContentShim: sensitivityModel) { state in
    ///     if let image = state.image {
    ///         image // Displays the loaded image.
    ///             .sensitiveOverlay(viewModel: sensitivityModel)
    ///     } else if state.error != nil {
    ///         Color.red // Indicates an error.
    ///     } else {
    ///         Color.blue // Acts as a placeholder.
    ///     }
    /// }
    /// ```
    ///
    /// - seealso: ``SwiftUI/View/sensitiveOverlay(viewModel:overlayTitle:clipShape:actionButtons:)``
    ///
    init(
        url: URL?,
        transaction: Transaction = Transaction(animation: nil),
        sensitiveContentShim: SensitiveContentShim,
        @ViewBuilder content: @escaping (LazyImageState) -> Content
    ) {
        self.init(
            request: url.map { ImageRequest(url: $0) },
            transaction: transaction,
            sensitiveContentShim: sensitiveContentShim,
            content: content
        )
    }
    
    /// Loads an images and displays custom content for each state, and attempts to
    /// check for sensitive content using the Sensitive Content Analysis framework (if
    /// enabled).
    ///
    /// - parameter url: The image URL.
    /// - parameter sensitiveContentShim: The ``SensitiveContentShim`` view model that
    ///   will perform content analysis and emit results to observers.
    /// - parameter content: The view to show for each of the image loading states.
    ///
    /// ```swift
    /// LazyImage(request: imageRequest, sensitiveContentShim: sensitivityModel) { state in
    ///     if let image = state.image {
    ///         image // Displays the loaded image.
    ///             .sensitiveOverlay(viewModel: sensitivityModel)
    ///     } else if state.error != nil {
    ///         Color.red // Indicates an error.
    ///     } else {
    ///         Color.blue // Acts as a placeholder.
    ///     }
    /// }
    /// ```
    ///
    /// - seealso: ``NukeUI/LazyImage/init(url:transaction:sensitiveContentShim:content:)``
    ///
    init(
        request: ImageRequest?,
        transaction: Transaction = Transaction(animation: nil),
        sensitiveContentShim: SensitiveContentShim,
        @ViewBuilder content: @escaping (LazyImageState) -> Content
    ) {
        sensitiveContentShim.analyzeImage(at: request?.url)
        self.init(request:request, transaction: transaction, content: content)
    }
}
