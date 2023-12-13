# Getting Started

Get started with `NukeSensitivty` to make integrating Apple's Sensitive Content Analysis with Nuke and NukeUI as easy as possible. 

## Overview

The code implementation for `NukeSensitivity` is quick and easy. However, your application **must** follow _all_ the necessary entitlement and provisioning setup steps to work properly. You should thouroughly test your application to ensure it behaves as intended _before_ shipping anything to production. [Apple's documentation](https://developer.apple.com/documentation/sensitivecontentanalysis/detecting-nudity-in-media-and-providing-intervention-options) goes into full detail about everything you need to do to get setup.

## Rendering a Sensitive LazyImage
`NukeSensitivity` provides three `LazyImage` initializers you can use to analyze an image for sensitive content. Each initializer almost exactly matches the existing non-sensitive initializers; you just need to pass an additional `sensitiveContentShim` parameter.

The `sensitiveContentShim` object you pass in should be an `Observable` instance of ``SensitiveContentShim`` which you maintain a reference to.

```swift
LazyImage(url: yourURL, sensitiveContentShim: sensitivityModel) { state in
    if let image = state.image {
        image // Displays the loaded image.
            .sensitiveOverlay(viewModel: sensitivityModel)
    } else if state.error != nil {
        Color.red // Indicates an error.
    } else {
        Color.blue // Acts as a placeholder.
    }
}
```

## Obscuring a Sensitive Image
Add the ``SwiftUI/View/sensitiveOverlay(viewModel:overlayTitle:clipShape:actionButtons:)`` modifier to a view to obscure its contents when the associated ``SensitiveContentShim`` detects sensitive content. If you're using one of the provided sensitive `LazyImage` initializers, pass the same shim into the view modifier. Each instance of ``SensitiveContentShim`` should be responsible for a single image's content.

The ``SwiftUI/View/sensitiveOverlay(viewModel:overlayTitle:clipShape:actionButtons:)`` modifier has a number of optional parameters you may use for customization.

### Overlay Title
Supply a custom overlay title to change the user-facing text shown when content is obscured. This parameter accepts a `LocalizableStringKey` so you may localize the provided value. The value you supply here will also be used as the view's accessibility label when obscured.

### Clip Shape
Oftentimes you may apply additional modifiers to images that you render in your application. For example, you may display profile photos in a `Circle`. If needed, you may pass in a `SwiftUI.Shape` to the `clipShape` parameter. This will clip the overlay content to the provided shape.

### Action Buttons
**Optional but recommended.** Pass in a `SwiftUI.View` that will be used to render a `SwiftUI.Menu` containing a warning-triangle in the top-trailing corner of the ``SensitiveImageOverlay``. If you do not provide a value here, no menu will be displayed and the button will be hidden.

```swift
image
    .sensitiveOverlay(viewModel: sensitivityModel) {
        Group {
            Button {
                showResources.toggle()
            } label: {
                Text("Ways to Get Help...")
            }
            Divider()
            Button(role: .destructive) {
                viewModel.blockUser()
            } label: {
                Text("Block User")
            }
        }
    }
```

## Responding to Sensitive Images
The last thing you'll need to do to get your code setup is to respond to changes in ``SensitiveContentShim``'s ``SensitiveContentShim/needsIntervention`` property. Setup a receiver to listen for changes to this property. When the value changes to `true`, you will need to step in to provide additional warnings to the user before allowing them to view the content. See [Apple's documentation on suggested additional interventions and warnings](https://developer.apple.com/documentation/sensitivecontentanalysis/detecting-nudity-in-media-and-providing-intervention-options#Tailor-user-interface-for-the-Communication-Safety-parental-control).

```swift
image
    .sensitiveOverlay(viewModel: sensitivityModel)
    .onReceive(sensitivityModel.$needsIntervention) { showWarning in
        showWarningSheet = showWarning
    }
    .sheet(isPresented: $showWarningSheet) {
        SensitiveContentWarningView(viewModel: sensitivityModel)
    }
```

```swift
struct SensitiveContentWarningView: View {

    @ObservedObject var viewModel: SensitiveContentShim

    var body: some View {
        // Your view content...
        // ...
        Button {
            viewModel.proceedToShowContent()
        } label: {
            Text("View")
        }
    }
}
```

## Important Reminders & Caveats
Remember that the use of the SensitiveContentAnalysis framework is _never_ to be used as a way to report on, track, or analyze a user's behavior. See this note from Apple:

> important: Apple provides the SensitiveContentAnalysis framework to prevent people from viewing unwanted content, not as a way for an app to report on someone’s behavior. To protect user privacy, don’t transmit any information off the user’s device about whether the SensitiveContentAnalysis framework has identified an image or video as containing nudity. For more information, see the [Developer Program License Agreement](https://developer.apple.com/programs/apple-developer-program-license-agreement/#sensitive-content-analysis-framework).
