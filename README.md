# RADAttribution iOS SDK

## Requirements

- iOS 10.0+
- Xcode 11+
- Swift 5+
- Ruby ([Installation Guide](./RubyInstallationGuide.md))
- [CocoaPods](https://cocoapods.org) 1.9.0+
```sh 
gem install cocoapods 
```

## Demo projects
* [RAD Advertiser Demo](./Demo/RADAdvertiser/)
* [RAD Publisher Demo](./Demo/RADPublisher/)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

RADAttribution is available through [CocoaPods](https://cocoapods.org) as private pod. To install
it, add the following line to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.rakops.com/MobileTracking/Specs.git'

target 'YOUR_TARGET_NAME' do
  
  use_frameworks!
  pod 'RADAttribution'
  
end
```

## Author

Rakuten Advertising

## License

RADAttribution iOS SDK is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
