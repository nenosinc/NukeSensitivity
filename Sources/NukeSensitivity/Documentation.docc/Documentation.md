# ``NukeSensitivity``
Easily detect and obscure sensitive content in images loaded and displayed with NukeUI.

## Overview
Starting in iOS 17.0 and macOS 14.0, Apple provides a Sensitive Content Analysis framework for use in applications where users may want to hide potentially sensitive images and video. This library bridges Nuke -- the asynchronous image loading library -- and Apple's framework to make it easy to obfuscate content for users who opt-in.

![Sensitive Content Analysis Framework in use example screenshots](apple_scakit_hero.png)

When a user who has opted-in to Sensitive Content Analysis (or has it enabled on their device via a parent / guardian), and the framework detects sensitive content, `NukeSensitivty` will automatically obscure the content and provide additional controls based on the user's settings. For users who have not opted-in, no analysis is performed and images load and display as they normally would with NukeUI.

Before using this library, you'll need to do some additional setup in your application. Please read the <doc:GettingStarted> document to learn more.

## Comaptibility
This library is compatible in projects targeting iOS 16 / macOS 13 and later. However, the Sensitive Content Analysis framework is only available on iOS 17.0 and macOS 14.0 and later. Use of the sensitive `LazyImage` initializers, `sensitiveOverlay`, and `SensitiveContentShim` have no effect on iOS / macOS versions prior to 17.0 / 14.0.

## Topics

### Loading Sensitive LazyImages

- ``NukeUI/LazyImage/init(url:sensitiveContentShim:)``
- ``NukeUI/LazyImage/init(url:transaction:sensitiveContentShim:content:)``
- ``NukeUI/LazyImage/init(request:transaction:sensitiveContentShim:content:)``

### Obscuring Sensitive LazyImages

- ``SwiftUI/View/sensitiveOverlay(viewModel:overlayTitle:clipShape:actionButtons:)``

### Managing Sensitive Actions

- ``SensitiveContentShim/needsIntervention``
- ``SensitiveContentShim/proceedToShowContent()``

### Customizing Implementation

- ``SensitiveContentShim``
- ``SensitiveImageOverlay``

### Debugging

- ``SensitiveContentShim/init(useFalsePositiveForDebug:)``
