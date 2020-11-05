#
# Be sure to run `pod lib lint RakutenAdvertisingAttribution.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RakutenAdvertisingAttribution'
  s.version          = '1.0.2'
  s.summary          = 'RakutenAdvertisingAttribution iOS SDK'

  s.description      = <<-DESC
Rakuten advertising attribution SDK allows advertisers to track app installs and in-app conversion events using any affiliate link promoted within a publisher’s mobile app or on a mobile web page.
                       DESC

  s.homepage         = 'https://github.com/Rakuten-Advertising-Developers/RakutenAdvertisingAttribution-iOS-SDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'Rakuten Advertising'
  s.source           = { :git => 'https://github.com/Rakuten-Advertising-Developers/RakutenAdvertisingAttribution-iOS-SDK.git', :tag => s.version.to_s }
  
  s.platform = :ios, "11.0"
  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files = 'RakutenAdvertisingAttribution/Source/**/*'

  s.dependency 'SwiftJWT'
end
