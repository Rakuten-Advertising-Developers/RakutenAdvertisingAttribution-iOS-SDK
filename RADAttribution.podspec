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
Rakuten Advertising Attribution iOS SDK, tracking events and deeplinking
                       DESC

  s.homepage         = 'https://github.com/Rakuten-Advertising-Developers/RADAttribution-SDK-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'Rakuten Advertising'
  s.source           = { :git => 'https://github.com/Rakuten-Advertising-Developers/RADAttribution-SDK-iOS.git', :branch => 'develop' } #:tag => s.version.to_s }
  
  s.platform = :ios, "11.0"
  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files = 'RADAttribution/Source/**/*'
  s.resources = 'RADAttribution/Assets/**/*'
  
  s.dependency 'SwiftJWT'

end
