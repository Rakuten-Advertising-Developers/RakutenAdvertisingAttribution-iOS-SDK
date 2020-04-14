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
* [RAd Advertiser Demo](https://github.com/Rakuten-Advertising-Developers/radadvertiser-demo-ios/)
* [RAd Publisher Demo](https://github.com/Rakuten-Advertising-Developers/radpublisher-demo-ios)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

RADAttribution is available through [CocoaPods](https://cocoapods.org) as private pod. To install
it, add the following line to your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/Rakuten-Advertising-Developers/Specs.git'

target 'YOUR_TARGET_NAME' do
  
  use_frameworks!
  pod 'RADAttribution'
  
end
```

## Author

Rakuten Advertising

## License

RADAttribution iOS SDK is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
