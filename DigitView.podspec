#
# Be sure to run `pod lib lint DigitView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DigitView'
  s.version          = '1.0.0'
  s.summary          = 'A simple UIView subclass that takes numbers as input in separate UITextFields.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/oyvinddd/digitview'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '43780301' => 'oyvind.s.hauge@gmail.com' }
  s.source           = { :git => 'git@github.com:oyvinddd/digitview.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'DigitView/Source/**/*'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
