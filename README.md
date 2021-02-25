# DigitView

[![CI Status](https://img.shields.io/travis/43780301/DigitView.svg?style=flat)](https://travis-ci.org/43780301/DigitView)
[![Version](https://img.shields.io/cocoapods/v/DigitView.svg?style=flat)](https://cocoapods.org/pods/DigitView)
[![License](https://img.shields.io/cocoapods/l/DigitView.svg?style=flat)](https://cocoapods.org/pods/DigitView)
[![Platform](https://img.shields.io/cocoapods/p/DigitView.svg?style=flat)](https://cocoapods.org/pods/DigitView)

## Introduction

UIView subclass that wraps separate UITextFields to create a custom digit input view. The delegate method `didFinishInput(_ input: String)` should be added to the view controller containing the digit view. The method will get called when the user has inserted a digit into every input field in the digit view.

## Installation

DigitView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DigitView'
```

## Author

43780301, oyvind.s.hauge@gmail.com

## License

DigitView is available under the MIT license. See the LICENSE file for more info.
