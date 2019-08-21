# WheelControl
iOS UIControl for selection an item (UIView) from 360° spinning wheel 
![](https://raw.githubusercontent.com/t0rn/WheelControl/master/WheelControl.gif)

## Usage
```swift
let emojiWheel = WheelControl()
let labels = emoji.map { text -> UILabel in
    let label = UILabel()
    label.text = text
    label.font = .systemFont(ofSize: 20)
    label.sizeToFit()
    return label
}
wheelControl.views = labels
