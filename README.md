# InputFieldView

[![CI Status](https://img.shields.io/travis/Frank/InputFieldView.svg?style=flat)](https://travis-ci.org/Frank/InputFieldView)
[![Version](https://img.shields.io/cocoapods/v/InputFieldView.svg?style=flat)](https://cocoapods.org/pods/InputFieldView)
[![License](https://img.shields.io/cocoapods/l/InputFieldView.svg?style=flat)](https://cocoapods.org/pods/InputFieldView)
[![Platform](https://img.shields.io/cocoapods/p/InputFieldView.svg?style=flat)](https://cocoapods.org/pods/InputFieldView)


<H4 align="center">
  InputFieldView is a UI library written in Swift. It makes easier to develop text field/text view based interfaces, such as account filed or remark field.
</H4>

## Examples

![State](https://github.com/FrankWuoO/InputFieldView/blob/master/Assets/example-1.gif)

Support state changes (`normal` -> `focus` -> `error`)

![Appearance](https://github.com/FrankWuoO/InputFieldView/blob/master/Assets/example-2.gif)

Support difference appearance, such as single or mutiple lines, state color(includes cursor), underline stroke, title and helper labels ...etc.

## Requirements

iOS 11 above

## Installation

InputFieldView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'InputFieldView'
```
## Usage

Initialize
```swift
    override func viewDidLoad() {
        super.viewDidLoad()

        let stateColors: [InputFieldView.State: UIColor] = [.normal: .gray,
                                                            .focus: .orange,
                                                            .error(""): .red]
        let appearance = InputFieldView.Appearance(stateColors: stateColors,
                                                   backgroundColor: UIColor.white,
                                                   strokeWidth: 0.5,
                                                   allowMultipleLines: false,
                                                   placeholder: nil,
                                                   labelText: "Title",
                                                   helperText: "Message")

        let fieldView = InputFieldView(appearance: appearance)
        fieldView.delegate = self
        view.addSubview(fieldView)
    }
```

Delegate methods
```swift
extension DemoViewController: InputFieldViewDelegate {
    func inputFieldViewDidBeginEditing(_ view: InputFieldView) {
        //Do something when user begins editing
    }

    func inputFieldViewDidEndEditing(_ view: InputFieldView) {
        //Do something when user ends editing, such as text validation
    }

    func inputFieldViewDidChangeText(_ view: InputFieldView) {
        //Do something when user changes text
    }
}
```

## Author

Frank, frankwu.cheng.en@gmail.com

## License

InputFieldView is available under the MIT license. See the LICENSE file for more info.
