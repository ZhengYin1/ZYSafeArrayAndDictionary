#
# Be sure to run `pod lib lint ZYSafeArrayAndDictionary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZYSafeArrayAndDictionary'
  s.version          = '0.1.0'
  s.summary          = 'Safe Array And Dictionary.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        Safe Array And Dictionary.
                       DESC

  s.homepage         = 'https://github.com/郑印/ZYSafeArrayAndDictionary'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '郑印' => 'zhengyin1@xiaomi.com' }
  s.source           = { :git => 'https://github.com/郑印/ZYSafeArrayAndDictionary.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ZYSafeArrayAndDictionary/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ZYSafeArrayAndDictionary' => ['ZYSafeArrayAndDictionary/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'AFNetworking', '~> 2.3'
end
