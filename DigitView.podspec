#
# Be sure to run `pod lib lint DigitView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DigitView'
  s.version          = '1.0.3'
  s.summary          = 'A simple UIView subclass that takes numbers as input in separate UITextFields.'

  s.description      = <<-DESC
  UIView subclass that wraps separate UITextFields to create a custom digit input view. The delegate method didFinishInput(_ input: String) should be added to the view controller containing the digit view. The method will get called when the user has inserted a digit into every input field in the digit view.
                       DESC

  s.homepage         = 'https://github.com/oyvinddd/digitview'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Øyvind Hauge' => 'oyvind.s.hauge@gmail.com' }
  s.source           = { :git => 'https://github.com/oyvinddd/digitview.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '12.0'

  s.source_files = 'Source/**/*.swift'
  s.swift_version = '5.0'
end
