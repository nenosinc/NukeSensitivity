//
//  SensitiveContentShim.swift
//  NukeSensitivity
//
//  Created by Sam Spencer on 12/10/23.
//  Copyright © 2023 nenos, Inc. All rights reserved.
//

import Combine
import Foundation
import SensitiveContentAnalysis
import SwiftUI

@MainActor public class SensitiveContentShim: ObservableObject {
    
    /// Publisher that, when `true`, indicates (1) sensitive content has been detected,
    /// (2) the user's settings require **additional** intervention before allowing
    /// sensitive content to be displayed, and (3) the user has made an **initial** request
    /// to _view_ the sensitive content.
    ///
    /// Views that load potentially sensitive content should listen for changes to this
    /// property. When set to true, you will need to provide additional warnings to the
    /// user to confirm that they would like to view the content. If, after presenting
    /// the additional confirmaitons to the user, they still choose to proceed, you may
    /// call ``proceedToShowContent()``.
    ///
    /// For more information on designing a sensitive content intervention screen, see
    /// [Tailor user interface for the Communication Safety parental control](https://developer.apple.com/documentation/sensitivecontentanalysis/detecting-nudity-in-media-and-providing-intervention-options#Tailor-user-interface-for-the-Communication-Safety-parental-control).
    ///
    @Published public var needsIntervention: Bool = false
    
    /// Publisher that indicates whether the user has elected to bypass obfuscation and
    /// requested that the sensitive content be shown.
    ///
    /// If you're using
    /// ``SwiftUI/View/sensitiveOverlay(viewModel:overlayTitle:clipShape:actionButtons:)``,
    /// this is handled for you.
    ///
    @Published public var showSensitiveContent: Bool = false
    
    /// Publisher that indicates whether the image provided to ``analyzeImage(at:)`` was
    /// flagged as containing sensitive content by the system.
    ///
    @Published public var isSensitive: Bool = false
    
    /// The current `SCSensitivityAnalysisPolicy` for this app.
    ///
    @Published public var policy: SCSensitivityAnalysisPolicy
    
    private let analyzer = SCSensitivityAnalyzer()
    private var triggerFalsePositive: Bool = false
    
    /// Create an instance of the `SensitiveContentShim` for use with
    /// ``NukeUI/LazyImage`` and the `sensitiveOverlay` modifier.
    ///
    /// - parameter useFalsePositiveForDebug: Set to true while debugging to force
    ///   false-positives in the system SCA framework. Defaults to `false`. Ignored if the
    ///   `DEBUG` compiler macro is undefined.
    ///
    public init(useFalsePositiveForDebug: Bool = false) {
        policy = analyzer.analysisPolicy
        
        #if DEBUG
        triggerFalsePositive = useFalsePositiveForDebug
        #endif
    }
    
    /// Directly analyze an image at a given URL for sensitive content.
    ///
    /// Publishes results to the ``SensitiveContentShim/isSensitive`` property.
    ///
    /// - note: It is not recommended to call this function explicitly. Instead, use
    /// ``NukeUI/LazyImage/init(url:transaction:sensitiveContentShim:content:)``, or one
    /// of the other initializers that accepts a ``SensitiveContentShim`` object.
    ///
    /// - parameter url: The URL of the potentially sensitive image.
    ///
    public func analyzeImage(at url: URL?) {
        guard let url, policy != .disabled else {
            showSensitiveContent = true
            isSensitive = false
            return
        }
        
        Task {
            var urlToAnalyze = url
            
            #if DEBUG
            if triggerFalsePositive {
                // This URL points to an Apple-provided QR code that will trigger a false-positive
                // in the SensitiveContentAnalysis Framework, despite the image having no sensitive
                // content.
                //
                // If you have turned on triggerFalsePositive and are not seeing the
                // SensitveImageOverlay rendered on your LazyImages, then you may not have properly
                // configured either your app's entitlements, the test configuration profile, or
                // the SensitiveImageOverlay modifier.
                //
                urlToAnalyze = URL(string: "https://developer.apple.com/sample-code/web/qr-sca.jpg")!
            }
            #endif
            
            let response = try await analyzer.analyzeImage(at: urlToAnalyze)
            isSensitive = response.isSensitive
        }
    }
    
    /// Immediately display sensitive content.
    ///
    /// - important: This should only be called in response to direct user-interaction
    ///   and confirmation.
    ///
    /// - seealso: ``needsIntervention``
    ///
    public func proceedToShowContent() {
        showSensitiveContent = true
    }
    
    /// Immediately hide sensitive content.
    ///
    /// If you're using
    /// ``SwiftUI/View/sensitiveOverlay(viewModel:overlayTitle:clipShape:actionButtons:)``,
    /// this is handled for you.
    ///
    public func hideContent() {
        showSensitiveContent = false
    }
    
    internal func requireIntervention() {
        needsIntervention = true
    }
    
}
