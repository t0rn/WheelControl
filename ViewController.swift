//
//  ViewController.swift
//  WheelControl
//
//  Created by Алексей Иванов on 10/07/2019.
//  Copyright © 2019 Alexey Ivanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var colorWheel: ColorViewWheelControl!
    @IBOutlet weak var emojiWheel: EmojiWheel!
    @IBOutlet weak var emojiLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let color = colorWheel.selectedView.backgroundColor else {return}
        updateUI(with: color)
    }

    @IBAction func colorWheelvalueChanged(_ sender: ColorViewWheelControl) {
        guard let color = sender.selectedView.backgroundColor else {return}
        updateUI(with: color)
    }
    
    @IBAction func emojiWheelValueChanged(_ sender: EmojiWheel) {
        guard let label = sender.selectedView as? UILabel,
            let emoji  = label.text else {return}
        emojiLabel.text = emoji
    }
    
    private func updateUI(with color: UIColor){
        UIView.animate(withDuration: 0.25) {
            self.view.backgroundColor = color
        }
    }
}

