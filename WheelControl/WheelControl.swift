//
//  WheelControl.swift
//  MyColorPicker
//
//  Created by Alexey Ivanov on 08/10/2018.
//  Copyright © 2018 com.alexey.ivanov. All rights reserved.
//

import UIKit

class WheelControl: UIControl {
    
    var selectedView: UIView {
        var index = currentAngle > 0 ? Int((currentAngle / angleStep).rounded()) - views.count : Int((currentAngle / angleStep).rounded())
        index = abs(index) % views.count
        return views[index]
    }
    
    var wheelColor: UIColor? = .darkGray {
        didSet{
            contentView.backgroundColor = wheelColor
        }
    }
    
    private let contentView = UIView(frame: .zero)
    
    private var circleRadius: CGFloat = 0.0
    
    private (set) var currentAngle: CGFloat = 0.0 {
        didSet {
            sendActions(for: .valueChanged)
        }
    }
    
    private var angleStep: CGFloat = 0.0
    
    var views: [UIView] {
        didSet {
            addViews(views)
        }
    }
    
    
    override init(frame: CGRect) {
        self.views = [UIView]()
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.views = [UIView]()
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        circleRadius = min(bounds.width, bounds.height/2)
        contentView.layer.cornerRadius = circleRadius
        addViews(views)
    }
    
    func commonInit() {
        backgroundColor = .clear
        clipsToBounds = true
        layer.masksToBounds = true
        
        contentView.backgroundColor = wheelColor
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 2.0
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        addSubview(contentView)
        
        //setup constraints
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    
        
    
        currentAngle = normalize(currentAngle)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        
        addGestureRecognizer(tapGestureRecognizer)
        let rotationRecognizer = RotationGestureRecognizer(target: self, action: #selector(handleRotationGesture(_:)))
        addGestureRecognizer(rotationRecognizer)
    }
    
    @objc private func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
        guard let view = recognizer.view else {return}
        
        let tPoint = recognizer.location(in: view)
        let touchPointAngle = rotationAngle(for: tPoint, in: view)
        let normRotationAngle = normalize(touchPointAngle)
        
        rotate(by: normRotationAngle, animated: true) { }
    
    }
    

    @objc private func handleRotationGesture(_ recognizer:RotationGestureRecognizer) {
        if recognizer.state == .failed,
            recognizer.state == .failed {
            return
        }
        var direction = recognizer.currentTouchAngle - recognizer.prevTouchAngle
        
        if recognizer.state == .ended {
            guard let view = recognizer.view else {return}
            //apply velocity
            let velocity = recognizer.velocity(in: view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideFactor = magnitude/1000

            var p = recognizer.location(in: view)
            p = CGPoint(x: p.x + (velocity.x * slideFactor), y: p.y + (velocity.y * slideFactor))

            let targetAngle = recognizer.angle(for: p, in: view)
            direction = targetAngle - recognizer.prevTouchAngle
            
            rotate(by: direction, animated: true) {
                self.rotateToNearestValue { }
            }
            return
        }
 
        rotate(by: direction, animated: true){ }
    }
    
    func normalize(_ angle: CGFloat) -> CGFloat {
        guard angle != 0.0 else {return 0.0}
        return CGFloat(roundf(Float(angle/angleStep))) * angleStep
    }

    
    private func addViews(_ views: [UIView]) {
        //remove prev
        contentView.subviews.forEach({ $0.removeFromSuperview() })
        
        angleStep = 2.0 * CGFloat.pi / CGFloat(views.count)
        
        for (i,view) in views.enumerated() {
            let r = circleRadius
            let angle = angleStep * CGFloat(i)
            
            let angleForPoint = CGFloat.pi - angle
            
            let offset:CGFloat = 20.0
            let xOffset: CGFloat = sin(angleForPoint) * (r - offset)
            let yOffset: CGFloat = cos(angleForPoint) * (r - offset)
            
            view.center = CGPoint(x: r+xOffset, y: r+yOffset)
            
            contentView.addSubview(view)
        }
    }

}


//MARK: Rotation
extension WheelControl {
    
    private func rotate(by angle:CGFloat, animated:Bool = false, duration: Double = 0.35, completion: @escaping (()->Void) )  {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.currentAngle = atan2(self.contentView.transform.b,
                                      self.contentView.transform.a)
            completion()
        })
        CATransaction.setDisableActions(true)
        
        if animated {
            CATransaction.setAnimationDuration(duration)
            let currentAngle = atan2(contentView.transform.b,
                                     contentView.transform.a)
            let newAngle = currentAngle + angle
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            animation.values = [currentAngle, newAngle]
            animation.keyTimes = [0.0, 1.0]
            animation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)]
            contentView.layer.add(animation, forKey: nil)
        }
        let transform = contentView.transform
        let newTransform = transform.rotated(by: angle)
        
        contentView.transform = newTransform
        
        CATransaction.commit()
    }
    
    private func rotateToNearestValue(with completion: (()->Void)?) {
        //use remainder in degrees instead radians
        let currentAngle = self.currentAngle * 180/CGFloat.pi
        let angleStep = self.angleStep * 180/CGFloat.pi
        let r = currentAngle.remainder(dividingBy: angleStep) * CGFloat.pi/180
        let rotationAngle = -r //revert sign for rotation!
        //TODO: pass animation duration considering acceleration
        rotate(by: rotationAngle, animated: true) {
            completion?()
        }
    }
    
    
    ///Returns angle to rotate on y axis by touch point to view center in rads
    private func rotationAngle(for point: CGPoint, in view: UIView) -> CGFloat {
        let centerOffset = CGPoint(x: point.x - view.bounds.midX, y: point.y - view.bounds.midY)
        var angle = atan2(centerOffset.y, centerOffset.x) + CGFloat.pi/2
        //QI
        if angle > 0, angle < CGFloat.pi/2 {
            angle = -angle
        }
            //QII
        else if angle < 0 {
            angle = -angle
        }
            //QIII
        else if angle < 3 * CGFloat.pi/2, angle > CGFloat.pi {
            angle = CGFloat.pi - angle + CGFloat.pi
        }
            //QIV
        else if angle < CGFloat.pi, angle > CGFloat.pi/2 {
            angle = -angle
        }
        return angle
    }
}
