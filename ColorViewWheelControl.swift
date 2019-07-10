//
//  ColorViewWheelControl.swift
//  WheelControl
//
//  Created by Алексей Иванов on 10/07/2019.
//  Copyright © 2019 Alexey Ivanov. All rights reserved.
//

import UIKit


@IBDesignable
class ColorViewWheelControl : WheelControl {
    override func commonInit() {
        super.commonInit()
        seedColorViews()
    }
    
    private func seedColorViews() {
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
        self.views = views
    }
}
