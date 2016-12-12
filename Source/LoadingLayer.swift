//
//  CircleAnimationLayer.swift
//  CocoaHUD
//
//  Created by Zhu Shengqi on 13/12/2016.
//  Copyright © 2016 zetasq. All rights reserved.
//

import UIKit

final class LoadingLayer: CALayer {
    init(frame: CGRect, beginColor: UIColor, endColor: UIColor, linewidth: CGFloat) {
        super.init()
        
        self.frame = frame

        let colors: [UIColor] = interpolationColors(from: beginColor, to: endColor)
        
        let gradientSize = CGSize(width: bounds.width / 2, height: bounds.height / 2)
        
        let gradientFrames = [CGRect(origin: CGPoint(x: bounds.width / 2, y: 0), size: gradientSize),
                              CGRect(origin: CGPoint(x: bounds.width / 2, y: bounds.height / 2), size: gradientSize),
                              CGRect(origin: CGPoint(x: 0, y: bounds.height / 2), size: gradientSize),
                              CGRect(origin: CGPoint(x: 0, y: 0), size: gradientSize)]
        
        let gradientDiagonals = [(CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1)),
                                 (CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1)),
                                 (CGPoint(x: 1, y: 1), CGPoint(x: 0, y: 0)),
                                 (CGPoint(x: 0, y: 1), CGPoint(x: 1, y: 0))]
        
        for i in 0..<4 {
            let gradientLayer = CAGradientLayer()
            
            gradientLayer.frame = gradientFrames[i]
            gradientLayer.colors = [colors[i].cgColor, colors[i + 1].cgColor]
            gradientLayer.startPoint = gradientDiagonals[i].0
            gradientLayer.endPoint = gradientDiagonals[i].1

            addSublayer(gradientLayer)
        }
        
        //Set mask
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.bounds = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        shapeLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.path = UIBezierPath(arcCenter: shapeLayer.position, radius: (shapeLayer.bounds.width - linewidth) / 2, startAngle: .pi * -0.5 + 0.2, endAngle: .pi * 1.5 - 0.2, clockwise: true).cgPath
        shapeLayer.lineWidth = linewidth
        shapeLayer.lineCap = kCALineCapRound

        mask = shapeLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func interpolationColors(from beginColor: UIColor, to endColor: UIColor) -> [UIColor] {
        var beginRed: CGFloat = 0
        var beginGreen: CGFloat = 0
        var beginBlue: CGFloat = 0
        var beginAlpha: CGFloat = 0
        beginColor.getRed(&beginRed, green: &beginGreen, blue: &beginBlue, alpha: &beginAlpha)
        
        var endRed: CGFloat = 0
        var endGreen: CGFloat = 0
        var endBlue: CGFloat = 0
        var endAlpha: CGFloat = 0
        endColor.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)
        
        var colors = [beginColor]
        
        for i in 1...3 {
            let intermediateRed = beginRed + (endRed - beginRed) * CGFloat(i) / 4
            let intermediateGreen = beginGreen + (endGreen - beginGreen) * CGFloat(i) / 4
            let intermediateBlue = beginBlue + (endBlue - beginBlue) * CGFloat(i) / 4
            let intermediateAlpha = beginAlpha + (endAlpha - beginAlpha) * CGFloat(i) / 4
            
            colors.append(UIColor(red: intermediateRed, green: intermediateGreen, blue: intermediateBlue, alpha: intermediateAlpha))
        }
        
        colors.append(endColor)
        
        return colors
    }
    
    func startAnimating() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.isRemovedOnCompletion = false
        animation.repeatCount = .infinity
        animation.fillMode = kCAFillModeForwards
        add(animation, forKey: "rotate")
    }
    
    func endAnimating() {
        removeAllAnimations()
    }
}
