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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorWheel.wheelColor = .lightGray

    }

}

