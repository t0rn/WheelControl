//
//  ViewController.swift
//  WheelControl
//
//  Created by Алексей Иванов on 10/07/2019.
//  Copyright © 2019 Alexey Ivanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var colorWheel: WheelControl!
    @IBOutlet weak var emojiWheel: WheelControl!
    @IBOutlet weak var emojiLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColorWheel()
        setupEmojiWheel()
        
        guard let color = colorWheel.selectedView.backgroundColor else {return}
        updateUI(with: color)
    }
    
    
    func setupColorWheel() {
        colorWheel.wheelColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        colorWheel.views = makeColorViews()
    }
    
    func setupEmojiWheel() {
        emojiWheel.wheelColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        emojiWheel.views = makeEmojiLabels()
    }
    
    @IBAction func colorWheelvalueChanged(_ sender: WheelControl) {
        guard let color = sender.selectedView.backgroundColor else {return}
        updateUI(with: color)
    }
    
    private func updateUI(with color: UIColor){
        UIView.animate(withDuration: 0.25) {
            self.view.backgroundColor = color
        }
    }
    
    @IBAction func emojiWheelValueChanged(_ sender: WheelControl) {
        guard let label = sender.selectedView as? UILabel,
            let emoji  = label.text else {return}
        emojiLabel.text = emoji
    }
    
    
    private func makeEmojiLabels() -> [UILabel] {
        let emoji = "😊,🥴,🙉,🐣,🐒,🤓,😎,🥳,🤨,😜,🤪,😃,😁,🧐,🤯"
            .split(separator: ",")
            .map{ String($0) }
        let labels = emoji.map { text -> UILabel in
            let label = UILabel()
            label.text = text
            label.font = .systemFont(ofSize: 20)
            label.sizeToFit()
            return label
        }
        return labels
    }
    
    private func makeColorViews() -> [UIView] {
        let n = 12
        let views = (0..<n).map{ (i) -> UIView in
            let color = UIColor(hue: CGFloat(i)/CGFloat(n),
                                saturation: 1.0,
                                brightness: 1.0,
                                alpha: 1.0)
            
            let frame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)
            let view = UIView(frame: frame)
            view.backgroundColor = color
            view.clipsToBounds = true
            view.layer.cornerRadius = frame.height/2
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.lightGray.cgColor
            return view
        }
        return views
    }
}

