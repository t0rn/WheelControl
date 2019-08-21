# WheelControl
iOS UIControl for selection an item (UIView) from 360° spinning wheel 

[![thumbnail image](https://img.youtube.com/vi/uYyMQqDiTcs/0.jpg)](https://www.youtube.com/watch?v=uYyMQqDiTcs)

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
