#
# Be sure to run `pod lib lint RADAttribution.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RADAttribution'
  s.version          = '0.0.1'
  s.summary          = 'Rakuten Advertising Attribution iOS SDK'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Rakuten Advertising Attribution iOS SDK
                       DESC

  s.homepage         = 'https://github.rakops.com/MobileTracking/RADAttribution-iOS-SDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'Rakuten Advertising'
  #s.source           = { :git => 'https://github.rakops.com/MobileTracking/RADAttribution-iOS-SDK.git', :tag => s.version.to_s }
  s.source           = { :git => 'https://github.rakops.com/MobileTracking/RADAttribution-iOS-SDK.git', :branch => 'develop' }
  
  s.platform = :ios, "10.0"
  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.source_files = 'RADAttribution/Source/**/*'

end
