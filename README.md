# RADAttribution iOS SDK
Rakuten advertising attribution SDK allows advertisers to track app installs and in-app conversion events using any affiliate link promoted within a publisher’s mobile app or on a mobile web page.

![PR Unit Tests](https://github.com/Rakuten-Advertising-Developers/RADAttribution-SDK-iOS/workflows/PR%20Unit%20Tests/badge.svg)
[![RADAttribution](https://raw.githubusercontent.com/Rakuten-Advertising-Developers/RADAttribution-SDK-iOS/master/docs/badge.svg?sanitize=true)](https://rakuten-advertising-developers.github.io/RADAttribution-SDK-iOS/)
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

#### RADAttributionKey generation by obfuscating private key

Private key obfuscation process avoids bundling the private key in executable file and make it hard for someone looking for senstive information by opening up your app's executable file.

RADAttribution SDK provides Obfuscator helper class to generate obfuscated key (RADAttributionKey). Run the below one time swift code in your project to generate RADAttributionKey. 

```swift

// secure your passphase in case needed to regenerate obfuscated key
 
let obfuscator = Obfuscator(with: "<your passphase>") 

//  copy the rad_rsa_private.pem content in <YOUR_RSA_PRIVATE_KEY>
let bytes = obfuscator.obfuscatingBytes(from: "<YOUR_RSA_PRIVATE_KEY>")

// TODO: remove the above two lines after key generation.


```

Run the above code in DEBUG mode and check for the following message (sample) in the console log.

```
--------------------
Salt used: <YOUR_SALT_STRING>
--------------------
Swift code:

struct SecretConstants {

    let RADAttributionKey: [UInt8] = [78, 66, 64, 3, 95, 35, 46, 50, 61, 43, 78, 124, 50, 37, 86, 53, 32, 61, 63, 50, 61, 
...
    91, 48, 5, 27, 1, 9, 103, 11, 21, 5, 39, 5, 7, 84, 33, 30, 60, 73, 6, 47, 34, 32, 30, 92, 35, 66, 83, 49, 48, 60, 20, 36, 81, 11, 38, 32, 94, 22, 2, 10, 48, 25, 12, 69, 8, 48, 46, 47, 36, 15, 0, 83, 39, 104, 85, 76, 64, 93, 41, 43, 39, 79, 63, 125, 51, 65, 59, 39, 61, 51, 47, 122, 36, 68, 61, 32, 43, 89, 68, 94, 68, 67]
}
```

The private key is required during the RADAttribution SDK initalization setup. Optionally you can copy the above swift code printed in the console in a new swift file (like SecretContants.swift) so you can pass key by the following command
```swift
let key = PrivateKey.data(value: obfuscator.revealData(from: SecretConstants().RADAttributionKey))
```

#### Setup RADAttribution SDK initalization

Initialize RADAttribution SDK with private key in `application:didFinishLaunchingWithOptions:`

1. Initialize `Configuration` struct instance with the key and launch options

```swift
let configuration = Configuration(key: PrivateKey.data(value: <Your RADAttributionKey>), launchOptions: launchOptions)
```
2. Pass configuration to `RADAttribution` SDK

```swift
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
In that case, you must confirm `LinkResolvableDelegate` in the place where you would like to handle response
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

RADAttribution SDK provides an ability to handle events like SEARCH,PURCHASE, ADD_TO_CART or any app activities you would like to handle on behalf of your business. 

Use `RADAttribution.shared.eventSender` to send your events. Send data associated with event in `eventData`



```swift
RADAttribution.shared.eventSender.sendEvent(name: "YOUR_EVENT_NAME", eventData: nil)
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
RADAttribution iOS SDK is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
