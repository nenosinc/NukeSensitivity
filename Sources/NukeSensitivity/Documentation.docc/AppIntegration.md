# App Integration and Testing

Configure your application entitlements and test devices to work with Sensitive Content Analysis.

## Overview

To properly use Apple's Sensitive Content Analysis framework, your application must include a special entitlement allowing it to call the system framework. Improper configuration by your application will result in the framework reporting that content analysis is `disabled`, whether it is or not, and rejecting any analysis requests.

Once the entitlement is added, your application becomes eligible to participate in sensitive content analysis. However, users maintain control over which applications have permission to do so.

To test analysis works as intended in your application, you'll need to do some additional setup as well.

### Add the entitlement

In Xcode, add `com.apple.developer.sensitivecontentanalysis.client` to your application's entitlements.

### Testing your application

 1. Download the [testing profile from Apple](https://developer.apple.com/documentation/sensitivecontentanalysis/testing-your-app-s-response-to-sensitive-media#Install-the-test-profile) and install it on your test device. Once installed, the profile is valid for a period of three days. You'll need to download and re-install the profile if you need additional time for testing.
 2. Pass `true` to the ``SensitiveContentShim/init(useFalsePositiveForDebug:)`` initializer in ``SensitiveContentShim``. When your app's `DEBUG` flag is set this will cause ``SensitiveContentShim`` to analyze the Apple-provided false-positive QR code instead of the provided image content. In configurations of your application where `DEBUG` is not set, this flag has no effect.
 3. Enable Sensitive Content Analysis in your device's Privacy settings. 
 4. On the next run of your application, all images loaded with a ``SensitiveContentShim`` whose `useFalsePositiveForDebug` property set to `true` should be obscured. If this is not the case, check that you've set up your entitlements and testing profile correctly and that Sensitive Content Analysis is enabled specifically for your app.
