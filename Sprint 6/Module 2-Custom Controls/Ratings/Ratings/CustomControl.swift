//
//  CustomControl.swift
//  Ratings
//
//  Created by Lisa Sampson on 8/28/18.
//  Copyright © 2018 Lisa Sampson. All rights reserved.
//

import UIKit

@IBDesignable class CustomControl: UIControl {
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        
        setup()
    }
    
    func setup() {
        
        for index in 1...componentCount {
            let x = CGFloat(index - 1)*(componentDimension + 8.0)
            let newLabel = UILabel(frame: CGRect(x: x, y: 0.0, width: componentDimension, height: componentDimension))
            newLabel.tag = index
            newLabel.font = UIFont.boldSystemFont(ofSize: 32.0)
            newLabel.text = "✰"
            newLabel.textAlignment = .center
            newLabel.textColor = index == 1 ? componentActiveColor : componentInactiveColor
            
            addSubview(newLabel)
            labels.append(newLabel)
        }
        
    }
    
    override var intrinsicContentSize: CGSize {
        let componentsWidth = CGFloat(componentCount) * componentDimension
        let componentsSpacing = CGFloat(componentCount + 1) * 8.0
        let width = componentsWidth + componentsSpacing
        return CGSize(width: width, height: componentDimension)
    }
    
    // MARK: - Touch Handling
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        updateValue(at: touch)
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        if bounds.contains(touchPoint) {
            sendActions(for: [.touchDragInside])
            updateValue(at: touch)
        } else {
            sendActions(for: [.touchDragOutside])
        }
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        guard let touch = touch else { return }
        let touchPoint = touch.location(in: self)
        if bounds.contains(touchPoint) {
            sendActions(for: [.touchUpInside])
            updateValue(at: touch)
        } else {
            sendActions(for: [.touchUpOutside])
        }
    }
    
    override func cancelTracking(with event: UIEvent?) {
        sendActions(for: [.touchCancel])
    }
    
    func updateValue(at touch: UITouch) {
        
        for label in labels {
            let touchPoint = touch.location(in: self)
            if label.frame.contains(touchPoint) {
                value = label.tag
                
                if value != previousValue {
                    previousValue = value
                    label.performFlare()
                    sendActions(for: [.valueChanged])
                }
            }
        }
        
        for label in labels {
            if label.tag <= value {
                label.textColor = componentActiveColor
            } else {
                label.textColor = componentInactiveColor
            }
        }
    }
    
    
    
    // MARK: - Properties
    
    var value: Int = 1
    var previousValue: Int = 1
    var labels = [UILabel]()
    
    private let componentDimension: CGFloat = 40.0
    private let componentCount = 6
    private let componentActiveColor = UIColor.black
    private let componentInactiveColor = UIColor.gray

}

extension UIView {
    // "Flare view" animation sequence
    func performFlare() {
        func flare()   {
            let scaleTransform = CGAffineTransform(scaleX: 1.6, y: 1.6)
            transform = scaleTransform.rotated(by: CGFloat.pi / 2)
            backgroundColor = .purple
            alpha = 0.5
        }
        func unflare() {
            transform = .identity
            backgroundColor = .clear
            alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.3,
                       animations: { flare() },
                       completion: { _ in UIView.animate(withDuration: 0.1) { unflare() }})
    }
}
