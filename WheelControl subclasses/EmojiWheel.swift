//
//  EmojiWheel.swift
//  WheelControl
//
//  Created by Алексей Иванов on 17/07/2019.
//  Copyright © 2019 Alexey Ivanov. All rights reserved.
//

import UIKit

class EmojiWheel : WheelControl {
    override func commonInit() {
        super.commonInit()
        wheelColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        let emoji = "😊,🥴,🙉,🐣,🐒,🤓,😎,🥳,🤨,😜,🤪,😃,😁,🧐,🤯"
            .split(separator: ",")
            .map{ String($0) }
        
        let labels = emoji.map { text -> UILabel in
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            label.numberOfLines = 0
            label.text = text
            label.font = .systemFont(ofSize: 20)
            label.sizeToFit()
            return label
        }
        self.views = labels
    }
}
