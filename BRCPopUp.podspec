#
# Be sure to run `pod lib lint BRCDropDown.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BRCPopUp'
  s.version          = '1.6.0'
  s.summary          = 'BRCPopUp is a versatile, highly customizable PopUp menu library for iOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'BRCPopUp is a highly customizable PopUp menu library for iOS, designed to enhance user interfaces with dynamic, visually appealing popUpMenu options. It supports extensive customization including arrow styles, popup animations, content alignment, and automatic dismissal behaviors. Ideal for applications requiring a flexible, adaptive UI component, BRCPopUp adapts seamlessly to various content types such as text, images, or custom views, making it a versatile choice for any iOS developer.'

  s.homepage         = 'https://github.com/JayChou202302/BRCPopUp'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhixiongsun' => 'jaychou202302@gmail.com' }
  s.source           = { :git => 'https://github.com/JayChou202302/BRCPopUp.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  
  s.swift_versions = '4.2'

  s.source_files = 'BRCPopUp/Classes/**/*'
  
  s.frameworks = 'UIKit','Foundation',"SwiftUI"
end
