# RADAttribution iOS SDK
Rakuten advertising attribution SDK allows advertisers to track app installs and in-app conversion events using any affiliate link promoted within a publisher’s mobile app or on a mobile web page.

![PR Unit Tests](https://github.com/Rakuten-Advertising-Developers/RADAttribution-SDK-iOS/workflows/PR%20Unit%20Tests/badge.svg)
[![RADAttribution](https://raw.githubusercontent.com/Rakuten-Advertising-Developers/RADAttribution-SDK-iOS/master/docs/badge.svg?sanitize=true)](https://rakuten-advertising-developers.github.io/RADAttribution-SDK-iOS/)
![GitHub](https://img.shields.io/github/license/Rakuten-Advertising-Developers/RADAttribution-SDK-iOS?label=License)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)

## Requirements

- iOS 11.0+
- Xcode 11+
- Swift 5+

## Import the RADAttribution SDK into your iOS workspace

Use [CocoaPods](https://cocoapods.org) to install RADAttribution private pod. If you dont have Cocoapods installed follow this [guide](https://guides.cocoapods.org/using/getting-started) for intallations. If you have Cocopods already installed add the following lines in your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/Rakuten-Advertising-Developers/Specs.git'

target 'YOUR_TARGET_NAME' do
  
  use_frameworks!
  pod 'RADAttribution'
  
end
```
Run the following command from your project's Podfile location
```sh 
pod install --repo-update 
```

#### Creating public/private key pairs
Our SDK internally uses a private key to sign a JSON Web Token(JWT). This token is passed to our Attribution backend system to verify the SDK's identity. 

Generate public/private key pairs with the following commands

```sh
openssl genpkey -algorithm RSA -out rad_rsa_private.pem -pkeyopt rsa_keygen_bits:256
openssl rsa -in rad_rsa_private.pem -pubout -out rad_rsa_public.pem
```
This command will create the following two files.
1. rad_rsa_private.pem: Store this private key securely. We dont recommended to store the private key in app bundles or source code. Follow the below steps for obfuscating the private key.
2. rad_rsa_public.pem: This file is required by Rakuten Attribution backend platform to verify the signature of the authentication JWT. (Public key handover process will be communicated separately)

#### Setup RADAttribution SDK initalization

> Optionally you can obfuscate your key [using the following guide](https://github.com/Rakuten-Advertising-Developers/RADAttribution-SDK-iOS/blob/master/guides/KeyObfuscatingGuide.md)

In your AppDelegate `application:didFinishLaunchingWithOptions:` initialize `Configuration` struct

```swift
let configuration = Configuration(key: PrivateKey.data(value: <Your Private Key>), launchOptions: launchOptions)
```

> Optionally you can provide another server information, for example for testing environment
```swift
let networkInfo = NetworkInfo(baseURL: "https://test.attribution.sdk.io", apiVersion: "v2", apiPath: "api")
let configuration = Configuration(key: PrivateKey.data(value: <Your Private Key>), launchOptions: launchOptions, backendURLProvider: networkInfo)
```

Then pass it to SDK
```Swift
RADAttribution.setup(with: configuration)
```

#### Handling INSTALL and OPEN events along with deeplink data

RADAttribution SDK provides a function to track app install and open events by itself. It also provides an ability to handle  deep link data if any associated with the affiliate link promoted within a publisher’s mobile app or on a mobile web page.

Simply call the `RADAttribution.shared.linkResolver` function whenever iOS app is brought to foreground.

In your AppDelegate use:
```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    
    RADAttribution.shared.linkResolver.resolveLink(url: url)
    return true
}

func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
       
    let resolved = RADAttribution.shared.linkResolver.resolve(userActivity: userActivity)
    if resolved {
        print("link available to resolve")
    } else {
        print("link unavailable to resolve")
    }
    return true
}
```
Optionally you can use `delegate` property of `linkResolver`, to handle deeplink data from the response
```swift
let vc = ViewController()
RADAttribution.shared.linkResolver.delegate = viewController
navigationController?.pushViewController(vc, animated: true)
```

In that case, you must confirm `LinkResolvableDelegate` in the place where you would like to handle response. Check [ResolveLinkResponse](https://rakuten-advertising-developers.github.io/RADAttribution-SDK-iOS/Structs/ResolveLinkResponse.html) struct documentation for details
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

#### Handing other events like SEARCH, ADD_TO_CART, PURCHASE or any app activities

RADAttribution SDK provides an ability to handle events like SEARCH, PURCHASE, ADD_TO_CART or any app activities you would like to handle on behalf of your business. 

Use `RADAttribution.shared.eventSender` to send your events.

```swift
let event = Event(name: "ADD_TO_CART")
RADAttribution.shared.eventSender.send(event: event)
```

Optionally you can provide additional data with an event. Check [Event struct](https://rakuten-advertising-developers.github.io/RADAttribution-SDK-iOS/Structs/Event.html) documentation.

```swift

let eventData = EventData(transactionId: "0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ",
                                         currency: "USD",
                                         revenue: 10,
                                         shipping: 15,
                                         tax: 7,
                                         coupon: "WcqiYwSzSaan",
                                         affiliation: "affiliation",
                                         description: "product description",
                                         searchQuery: "search query")
        
let customData: EventCustomData = ["purchase_loc": "Palo Alto",
                                   "store_pickup": "unavailable"]
        
let content1: EventContentItem = [.price: 100,
                                  .quantity: 1,
                                  .sku: "788672541568328428",
                                  .productName: "First Product Name"]
        
let content2: EventContentItem = [.price: 150,
                                  .quantity: 2,
                                  .sku: "788672541527138674",
                                  .productName: "Second Product Name"]
        
let event = Event(name: "PURCHASE",
                  eventData: eventData,
                  customData: customData,
                  contentItems: [content1, content2])

RADAttribution.shared.eventSender.send(event: event)

```

Similarly, you can use `delegate` property of `eventSender`, to track statuses of sending events
```swift
let vc = ViewController()
RADAttribution.shared.eventSender.delegate = viewController
navigationController?.pushViewController(vc, animated: true)
```
Confirm to `EventSenderableDelegate` in a place where you would like to receive statuses
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
#### Logging
For debugging purpose you can enable network logs. `RADAttribution.shared.logger` property is responsible for this process.
```swift
RADAttribution.shared.logger.enabled = true
```
## Demo app
We provide a sample app that demonstrate the use of the Rakuten Advertising attribution SDK. You can find the open source application at this Git Repsitory
* [RAd Advertiser Demo](https://github.com/Rakuten-Advertising-Developers/radadvertiser-demo-ios/)

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage
> All examples require `import RADAttribution` somewhere in the source file.

## Documentation
* [API References](https://rakuten-advertising-developers.github.io/RADAttribution-SDK-iOS/)


## Author
Rakuten Advertising

## License
RADAttribution iOS SDK is available under the MIT license. See the [LICENSE](https://github.com/Rakuten-Advertising-Developers/RADAttribution-SDK-iOS/blob/master/LICENSE) file for more info.
