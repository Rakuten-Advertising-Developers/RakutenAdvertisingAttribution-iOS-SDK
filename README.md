# RakutenAdvertisingAttribution iOS SDK
Our attribution SDK enables you to track app activity, including installs and purchase events, within your affiliate program.
> **Important:** We recommend reading through the entire SDK documentation before beginning your SDK integration to make sure everything is clear. Your Implementation Specialist is happy to answer any questions you may have. Engineering support is also available to you as needed. 


![PR Unit Tests](https://github.com/Rakuten-Advertising-Developers/RakutenAdvertisingAttribution-iOS-SDK/workflows/PR%20Unit%20Tests/badge.svg)
[![RakutenAdvertisingAttribution](https://raw.githubusercontent.com/Rakuten-Advertising-Developers/RakutenAdvertisingAttribution-iOS-SDK-API-References/master/docs/badge.svg)](https://rakuten-advertising-developers.github.io/RakutenAdvertisingAttribution-iOS-SDK-API-References/)
![GitHub](https://img.shields.io/github/license/Rakuten-Advertising-Developers/RakutenAdvertisingAttribution-iOS-SDK?label=License)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)

## Requirements

- iOS 11.0+
- Xcode 11+
- Swift 5+

## Import the attribution SDK into your iOS workspace

##### CocoaPods
Use [CocoaPods](https://cocoapods.org) to install attribution SDK as a pod. If you don’t have Cocoapods installed, follow this [guide](https://guides.cocoapods.org/using/getting-started) for intallations. If you have Cocopods already installed add the following lines in your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/Rakuten-Advertising-Developers/Specs.git'

target 'YOUR_TARGET_NAME' do
  
  use_frameworks!
  pod 'RakutenAdvertisingAttribution'
  
end
```
Run the following command from your project's Podfile location
```sh 
pod install --repo-update 
```

##### Swift Package Manager
Also you can use the Swift Package Manager as integration method. If you want to use the Swift Package Manager as integration method, either [use Xcode to add the package dependency](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) or add the following dependency to your `Package.swift`:


```swift
dependencies: [
    .package(name: "RakutenAdvertisingAttribution", 
             url: "https://github.com/Rakuten-Advertising-Developers/RakutenAdvertisingAttribution-iOS-SDK.git", 
             .upToNextMajor(from: "1.0.0"))
]
```

#### Creating public/private key pairs
To integrate the SDK into your application, you must generate public/private key pairs using the following commands.

```sh
openssl genrsa -out rad_rsa_private.pem 4096
openssl rsa -in rad_rsa_private.pem -outform PEM -pubout -out rad_rsa_public.pem
```
The above commands will create the following two files.
1. **rad_rsa_private.pem:** Store this private key securely. This key is required by the SDK to report events to our attribution server in a secured manner. We recommend obfuscating the private key which is required during SDK initialization. To obfuscate the private key, follow the instructions the “Private Key Obfuscation steps” section.
2. **rad_rsa_public.pem:** This file is required by our attribution server to verify the signature.

> **Note:** Email the rad_ras_public.pem public key and your app bundle id details to ra-sdk-support@mail.rakuten.com

#### Setup attribution SDK initialization

> Optionally you can obfuscate your key [using the following guide](https://github.com/Rakuten-Advertising-Developers/RakutenAdvertisingAttribution-iOS-SDK/blob/master/guides/KeyObfuscatingGuide.md)

In your AppDelegate `application:didFinishLaunchingWithOptions:` initialize `Configuration` struct

```swift
let configuration = Configuration(key: PrivateKey.data(value: <Your Private Key>), 
                                  launchOptions: launchOptions)
```

> Optionally you can provide another server information, for example for stage environment

```swift
let backendInfo = BackendInfo.stageConfiguration
let configuration = Configuration(key: PrivateKey.data(value: <Your Private Key>), 
                                  launchOptions: launchOptions, 
                                  backendURLProvider: backendInfo)
```

Then pass it to SDK
```Swift
RakutenAdvertisingAttribution.setup(with: configuration)
```

#### Handling INSTALL and OPEN events along with deeplink data

Our attribution SDK provides a function (resolve) to capture app install events automatically.
Simply call the `RakutenAdvertisingAttribution.shared.linkResolver.resolve` function in AppDeletgate foreground method.
In your AppDelegate use:
```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {

    RakutenAdvertisingAttribution.shared.linkResolver.resolve(url: url)
    return true
}

func application(_ application: UIApplication,
                continue userActivity: NSUserActivity,
                restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

    RakutenAdvertisingAttribution.shared.linkResolver.resolve(userActivity: userActivity)
    return true
}
```
Optionally you can use `delegate` property of `linkResolver`, to handle deeplink data from the response
```swift
let vc = ViewController()
RakutenAdvertisingAttribution.shared.linkResolver.delegate = viewController
navigationController?.pushViewController(vc, animated: true)
```

In that case, you must confirm `LinkResolvableDelegate` in the place where you would like to handle response. Check [ResolveLinkResponse](https://rakuten-advertising-developers.github.io/RakutenAdvertisingAttribution-iOS-SDK-API-References/Structs/ResolveLinkResponse.html) struct documentation for details
```swift
extension ViewController: LinkResolvableDelegate {
    
    func didResolveLink(response: ResolveLinkResponse) {
        DispatchQueue.main.async { [weak self] in
            //success handle deeplink data response
        }
    }
    
    func didFailedResolve(link: String, with error: Error) {
        DispatchQueue.main.async { [weak self] in
            //error case handling
        }
    }
}
```
When the app launches for the first time after installation, the resolve() method flags the session as the first session and our attribution server records the event as an INSTALL.

> **Important:** When `resolve()` is called, our attribution server will attempt to attribute the event to an affiliate link referral. Please follow your business requirement on when to call `resolve()`.  Any excluding logic is the individual developer’s responsibility; however, we have included the following sample code to illustrate how to call `resolve()` for specific traffic.
```swift
func shouldIgnoreLinkResolver(userActivity: NSUserActivity) -> Bool {
    guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
          let incomingURL = userActivity.webpageURL,
          let host = incomingURL.host else { return false }
    let excludedDomains: Set<String> = ["example.com", "excluded.com"]
    return excludedDomains.contains(host)
}
func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    if !shouldIgnoreLinkResolver(userActivity: userActivity) {
            RakutenAdvertisingAttribution.shared.linkResolver.resolve(userActivity: userActivity)
        }
    return true
}
```

#### IDFA

For improving user experience you can also provide advertising information. Starting from iOS 14 Apple made a couple of changes relating to receiving IDFA data. Here code sample which you can use, to retrieve this value for iOS14 and also for previous versions as well.

> Don't forget to add to Info.plist tracking usage description information
```xml
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>
```

```swift
import Foundation
import AdSupport

#if canImport(AppTrackingTransparency)
    import AppTrackingTransparency
#endif

typealias IDFAFetcherCompletion = ((Bool, UUID) -> Void)

class IDFAFetcher {

    // MARK: Internal
    
    static func fetchIfAuthorized(completion: IDFAFetcherCompletion) {
        
        let enabled: Bool
        if #available(iOS 14, *) {
            enabled = ATTrackingManager.trackingAuthorizationStatus == .authorized
        } else {
            enabled = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
        }
        let identifier = ASIdentifierManager.shared().advertisingIdentifier
        
        completion(enabled, identifier)
    }

    static func requestTracking(receiveOn queue: DispatchQueue = DispatchQueue.main,
                                completion: @escaping IDFAFetcherCompletion) {

        let innerCompletion: () -> Void = {
            queue.async {
                fetchIfAuthorized(completion: completion)
            }
        }

        if #available(iOS 14, *) {
            if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                ATTrackingManager.requestTrackingAuthorization { _ in
                    innerCompletion()
                }
            } else {
                innerCompletion()
            }
        } else {
            innerCompletion()
        }
    }
}
```

Then call it and pass parameters to SDK (ideally in AppDelegate during SDK initialization)

```swift
IDFAFetcher.fetchIfAuthorized {
    RakutenAdvertisingAttribution.shared.adSupport.isTrackingEnabled = $0
    RakutenAdvertisingAttribution.shared.adSupport.advertisingIdentifier = $1.uuidString
}
```

Also, request for tracking is mandatory. Please ask the user at an appropriate time in your app (SDK will ignore all event until receive consent from user)
```swift
IDFAFetcher.requestTracking {
    RakutenAdvertisingAttribution.shared.adSupport.isTrackingEnabled = $0
    RakutenAdvertisingAttribution.shared.adSupport.advertisingIdentifier = $1.uuidString
}
```

#### Handling Purchase Events

Our attribution SDK provides a function `RakutenAdvertisingAttribution.shared.eventSender` to capture in-app purchase events.  Upon successfully completing the order processing routine, call the `RakutenAdvertisingAttribution.shared.eventSender` function passing details about the purchase.

Sample purchase event reporting code:
```swift
// Item level details (item1)
let content1: EventContentItem = [.price: 100,
                                  .quantity: 1,
                                  .sku: "788672541568328428",
                                  .productName: "First Product Name"]
// Item level details (item2)
let content2: EventContentItem = [.price: 150,
                                  .quantity: 2,
                                  .sku: "788672541527138674",
                                  .productName: "Second Product Name"]
// if you have more items continue with content3, content4 and so on and include in the Event() as below
// Order details 
let eventData = EventData(transactionId: "12345",
                                         currency: "USD",
                                         revenue: 415,
                                         shipping: 15,
                                         tax: 7)                                
let event = Event(name: "PURCHASE",
                  eventData: eventData,
                  contentItems: [content1, content2])
RakutenAdvertisingAttribution.shared.eventSender.send(event: event)
```

Similarly, you can use `delegate` property of `eventSender`, to track status of sending events
```swift
let vc = ViewController()
RakutenAdvertisingAttribution.shared.eventSender.delegate = viewController
navigationController?.pushViewController(vc, animated: true)
```
Confirm to `EventSenderableDelegate` in a place where you would like to receive status
```swift
extension ViewController: EventSenderableDelegate {
    
    func didSend(eventName: String, resultMessage: String) {
        DispatchQueue.main.async { [weak self] in
            //success case handling
        }
    }
    
    func didFailedSend(eventName: String, with error: Error) {
        DispatchQueue.main.async { [weak self] in
            //error case handling
        }
    }
}
```
#### Debugging
For debugging enable the logger as below:
```swift
RakutenAdvertisingAttribution.shared.logger.enabled = true
```
Once the logging flag enabled, you will be able to see resolve() and sendEvent() request and response payloads in the debug console.

Sample debug log:
```
RakutenAdvertisingAttribution.Logger 
----->
POST https://attribution-sdk-endpoint-z7j3tzzl4q-uc.a.run.app/v2/resolve-link-rak
HEADERS: {
  "Content-Type" : "application\/json",
  "Authorization" : "Bearer eyJ0eX <...> EuY"
}
BODY: {
  "device_data" : {
    "is_simulator" : true,
    "os" : "iOS",
    "device_id" : "DA128118-C52B-4EAA-9F65-4C6A6F686F66",
    "screen_width" : 414,
    "model" : "iPhone",
    "os_version" : "14.0",
    "screen_height" : 896,
    "ios_vendor_id" : "DA128118-C52B-4EAA-9F65-4C6A6F686F66",
    "fingerprint" : "{\"userAgent\":\"Mozilla\/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit\/605.1.15 (KHTML, like Gecko) Mobile\/15E148\",\"webdriver\":false,\"language\":\"en-us\",\"colorDepth\":32,\"deviceMemory\":\"not available\",\"pixelRatio\":2,\"hardwareConcurrency\":\"not available\",\"screenResolution\":[896,414],\"availableScreenResolution\":[896,414],\"timezoneOffset\":-180,\"timezone\":\"Europe\/Kiev\",\"sessionStorage\":true,\"localStorage\":true,\"indexedDb\":true,\"addBehavior\":false,\"openDatabase\":false,\"cpuClass\":\"not available\",\"platform\":\"iPhone\",\"doNotTrack\":\"not available\",\"webglVendorAndRenderer\":\"Apple Inc.~Apple GPU\",\"adBlock\":false,\"hasLiedLanguages\":false,\"hasLiedResolution\":false,\"hasLiedOs\":false,\"hasLiedBrowser\":false,\"touchSupport\":[5,true,true],\"fontsFlash\":\"swf object not loaded\",\"audio\":\"35.10892752557993\",\"ip\":\"192.168.1.2\"}",
    "hardware_id_type" : "vendor_id"
  },
  "universal_link_url" : "",
  "first_session" : false,
  "user_data" : {
    "sdk_version" : "1.0.0",
    "bundle_identifier" : "com.rakutenadvertising.RADAttribution-Example",
    "app_version" : "1.0.0"
  }
}
----->

RakutenAdvertisingAttribution.Logger 
<-----
POST https://attribution-sdk-endpoint-z7j3tzzl4q-uc.a.run.app/v2/resolve-link-rak
CODE: 200
RESPONSE: {
  "session_id" : "5f6c7374421aa900012733c4",
  "link" : "",
  "click_timestamp" : 0,
  "device_fingerprint_id" : "5f6c7374421aa9000127343f"
}
<-----
```
> **IMPORTANT:** We recommend disabling debugging in the production build.

## Demo app
We provide a sample app that demonstrate the use of the Rakuten Advertising attribution SDK. You can find the open source application at this Git Repsitory
* [RAd Advertiser Demo](https://github.com/Rakuten-Advertising-Developers/radadvertiser-demo-ios/)

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage
> All examples require `import RakutenAdvertisingAttribution` somewhere in the source file.

## Documentation
* [API References](https://rakuten-advertising-developers.github.io/RakutenAdvertisingAttribution-iOS-SDK-API-References/)

## Author
Rakuten Advertising

## License
RakutenAdvertisingAttribution iOS SDK is available under the MIT license. See the [LICENSE](https://github.com/Rakuten-Advertising-Developers/RakutenAdvertisingAttribution-iOS-SDK/blob/master/LICENSE) file for more info.
