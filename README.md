# RADAttribution iOS SDK
Rakuten advertising attribution SDK allows advertisers to track app installs and in-app conversion events using any affiliate link promoted within a publisher’s mobile app or on a mobile web page.

![PR Unit Tests](https://github.com/Rakuten-Advertising-Developers/RADAttribution-SDK-iOS/workflows/PR%20Unit%20Tests/badge.svg)
[![RADAttribution](https://raw.githubusercontent.com/Rakuten-Advertising-Developers/RADAttribution-SDK-iOS/master/docs/badge.svg?sanitize=true)](https://rakuten-advertising-developers.github.io/RADAttribution-SDK-iOS/)
## Requirements

- iOS 11.0+
- Xcode 11+
- Swift 5+
<!--
- Ruby ([Installation Guide](./guides/RubyInstallationGuide.md))
- [CocoaPods](https://cocoapods.org) 1.9.0+
```sh 
gem install cocoapods 
```
<-->



## Import the RADAttribution SDK into your iOS workspace

Use [CocoaPods](https://cocoapods.org) to install RADAttribution private pod. If you dont have Cocoapods installed follow this guide[https://guides.cocoapods.org/using/getting-started] for intallations. If you have Cocopods already installed add the following lines in your Podfile:

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
Our SDK internally uses a private key to sign a JSON Web Token(JWT). This token is passed to our Attribution backend platform to verify the SDK's identity. 

Generate public/private key pairs with the following commands

```sh
openssl genpkey -algorithm RSA -out rad_rsa_private.pem -pkeyopt rsa_keygen_bits:256
openssl rsa -in rad_rsa_private.pem -pubout -out rad_rsa_public.pem
```
This command will create the following two files.
1. rad_rsa_private.pem: Store this private key securely. We dont recommended to store the private key in app bundles or source code. Follow the below steps for obfuscating the private key.
2. rad_rsa_public.pem: This file is required by Rakuten Attribution backend platform to verify the signature of the authentication JWT. Public key handover process will be communicated separately.

#### Obfuscating private key

Private key obfuscation process avoids bundling the private key in executable file and make it hard for someone looking for senstive information by opening up your app's executable file.

#### Setup RADAttribution SDK initalization
Before using RADAttribution SDK you have to properly setup it in `application:didFinishLaunchingWithOptions:`
1. Receive and [prepare private key](./guides/KeyPreparationGuide.md)
2. Initialize `Configuration` struct instance passing your generated private key and launch options
```swift
let configuration = Configuration(key: .data(value: privateKey), launchOptions: launchOptions)
```
3. Pass configuration to `RADAttribution` SDK
```swift
RADAttribution.setup(with: configuration)
```

#### Resolving links
RADAttribution provides ability to resolve links from Publisher applications, `RADAttribution.shared.linkResolver` property is responsible for this process. In your AppDelegate use:
```swift
func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
       
    let resolved = RADAttribution.shared.linkResolver.resolve(userActivity: userActivity)
    if resolved {
        //success case handling
    } else {
        //error case handling
    }
    return true
}
```
Optionally you can use `delegate` property of `linkResolver`, to track statuses of the process
```swift
let vc = ViewController()
RADAttribution.shared.linkResolver.delegate = viewController
navigationController?.pushViewController(vc, animated: true)
```
In that case, you must confirm `LinkResolvableDelegate` in the place where you would like to receive statuses
```swift
extension ViewController: LinkResolvableDelegate {
    
    func didResolve(link: String, resultMessage: String) {
        DispatchQueue.main.async { [weak self] in
            //success case handling
        }
    }
    
    func didFailedResolve(link: String, with error: Error) {
        DispatchQueue.main.async { [weak self] in
            //error case handling
        }
    }
}
```
#### Send Events
Another option of RADAttribution is ability to send events. `RADAttribution.shared.eventSender` property is responsible for this purpose. To send your events, use the following code. (optionally you can pass additional information with `EventData` struct)
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
