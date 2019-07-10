//
//  RotationGestureRecognizer.swift
//  MyColorPicker
//
//  Created by Alexey Ivanov on 10/10/2018.
//  Copyright © 2018 com.alexey.ivanov. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class RotationGestureRecognizer: UIPanGestureRecognizer {
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        minimumNumberOfTouches = 1
        maximumNumberOfTouches = 1
    }
    
    private(set) var currentTouchAngle: CGFloat = 0
    private(set) var prevTouchAngle: CGFloat = 0
    
    //MARK: Overridden
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)

        updateDirection(with: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        updateDirection(with: touches)
    }
    
    private func updateDirection(with touches: Set<UITouch>) {
        guard let touch = touches.first,
            let view = view else { return }
        
        let currentTouchPoint = touch.location(in: view)
        let previousTouchPoint = touch.previousLocation(in: view)
        
        currentTouchAngle = angle(for: currentTouchPoint, in: view)
        prevTouchAngle = angle(for: previousTouchPoint, in: view)
    }
    
    func angle(for point: CGPoint, in view: UIView) -> CGFloat {
        let centerOffset = CGPoint(x: point.x - view.bounds.midX, y: point.y - view.bounds.midY)
        guard false == centerOffset.x.isNaN, false == centerOffset.y.isNaN else { return 0.0 }
        return atan2(centerOffset.y, centerOffset.x)
    }
    
}
