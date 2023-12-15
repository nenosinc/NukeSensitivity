# NukeSensitivity
iOS 17 Sensitive Content Analysis integration for [Nuke](https://github.com/kean/Nuke) written in swift. 

NukeSensitivity makes it easy to detect and obscure sensitive content in images loaded and displayed with NukeUI.

## Overview
Starting in iOS 17.0 and macOS 14.0, Apple provides a [Sensitive Content Analysis framework](https://developer.apple.com/documentation/sensitivecontentanalysis) for use in applications where users may want to hide potentially sensitive images and video. This library bridges Nuke -- the asynchronous image loading library -- and Apple's framework to make it easy to obfuscate content for users who opt-in.

![Sensitive Content Analysis Framework in use example screenshots](https://github.com/nenosllc/NukeSensitivity/blob/ff3092b9bd0977c7afee729404b932f650aa1ec6/Sources/NukeSensitivity/Documentation.docc/Resources/apple_scakit_hero.png)

When a user who has opted-in to Sensitive Content Analysis (or has it enabled on their device via a parent / guardian), and the framework detects sensitive content, `NukeSensitivty` will automatically obscure the content and provide additional controls based on the user's settings. For users who have not opted-in, no analysis is performed and images load and display as they normally would with NukeUI.

Before using this library, you'll need to do some additional setup in your application. Please read through the included documentation to learn more.

## Getting Started
Integrating NukeSensitivity with your existing NukeUI setup is as easy as updating your `LazyImage` initializer to accept a `SensitiveContentShim` object and setting a `sensitiveOverlay` modifier on the returned image.

```swift
@ObservedObject var sensitivityModel = SensitiveContentShim()

// ... your SwiftUI view ...

LazyImage(url: yourURL, sensitiveContentShim: sensitivityModel) { state in
    if let image = state.image {
        image // Displays the loaded image.
            .sensitiveOverlay(viewModel: sensitivityModel)
    } else if state.error != nil {
        Color.red // Indicates an error.
    } else {
        Color.secondarySystemFill // Acts as a placeholder.
    }
}
```

For the full documentation and setup, please refer to the included DocC documentation.

## Minimum Requirements

| Swift | Xcode | iOS | macOS | tvOS | watchOS |
|:-----:|:-----:|:---:|:-----:|:----:|:-------:|
| 5.7 | 15.0 | 16.0 | 13.0 | Unavailable | Unavailable |

This library is compatible in projects targeting iOS 16 / macOS 13 and later. However, the Sensitive Content Analysis framework is only available on iOS 17.0 and macOS 14.0 and later. Use of the sensitive `LazyImage` initializers, `sensitiveOverlay`, and `SensitiveContentShim` have no effect on iOS / macOS versions prior to 17.0 / 14.0.

## Dependencies
| [Nuke](https://github.com/kean/Nuke) |
|:---:|
| >= 12.0.0 |

## License

NukeSensitivity is available under the MIT license. See the LICENSE file for more info.
