//
//  IGActivityIndicator.swift
//  LearningGradients
//
//  Created by Bao Long on 11/05/2023.
//

import Foundation
import QuartzCore
import UIKit

class InstagramStoryLayer: CAGradientLayer {
    var yellowColor = UIColor.init(red: 249/255, green: 260/255, blue: 52/255, alpha: 1).cgColor
    var redColor = UIColor.init(red: 238/255, green: 42/255, blue: 123/255, alpha: 1).cgColor
    var blueColor = UIColor.init(red: 98/255, green: 40/255, blue: 215/255, alpha: 1).cgColor

    var replicatorLayer = CAReplicatorLayer()
    var segmentLayer = CAShapeLayer()
    var animationDuration: Double
    var rotationDuration: Double
    var numSegments: Int
    var lineWidth : CGFloat
    var isAnimating: Bool = false
    
    init(centerPoint: CGPoint,
         width: CGFloat = 10,
        animationDuration: Double = 1,
        rotationDuration: Double = 7,
        lineWidth : CGFloat = 5)
    {
        self.animationDuration = animationDuration
        self.rotationDuration = rotationDuration
        self.numSegments = 20
        self.lineWidth = lineWidth
        
        super.init()
        self.startPoint = CGPoint(x: 0.0, y: 1.0)
        self.endPoint = CGPoint(x: 1.0, y: 0.0)
        self.colors = [yellowColor, redColor, blueColor]
        self.locations = [0, 0.4, 1]
        self.mask = replicatorLayer
        self.frame = CGRect(x: centerPoint.x - width / 2 ,
                            y: centerPoint.y - width / 2,
                            width: width,
                            height: width)
        settingSegment()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func settingSegment() {
        segmentLayer.lineCap = CAShapeLayerLineCap.round
        segmentLayer.fillColor = nil
        replicatorLayer.addSublayer(segmentLayer)
        
        replicatorLayer.frame = self.bounds
        let angle = 2 * CGFloat.pi / CGFloat(numSegments)
        replicatorLayer.instanceCount = numSegments
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
        replicatorLayer.instanceDelay = 1.5 * animationDuration / Double(numSegments)
        
        let maxRadius = max(0,min(replicatorLayer.bounds.width, replicatorLayer.bounds.height))/2
        let radius: CGFloat = maxRadius - lineWidth/2
        
        let path = UIBezierPath(arcCenter: CGPoint(x: maxRadius, y: maxRadius), radius: radius, startAngle: -angle/2 - CGFloat.pi/2, endAngle: angle/2 - CGFloat.pi/2, clockwise: true)
        segmentLayer.lineWidth = lineWidth
        segmentLayer.strokeColor = UIColor.blue.cgColor
        segmentLayer.path = path.cgPath
        
    }
    
    func startAnimation() {
        isAnimating = true
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.byValue = CGFloat.pi*2
        rotate.duration = rotationDuration
        rotate.repeatCount = Float.infinity
        
        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        strokeStart.fromValue = 0.0
        strokeStart.toValue = 0.6
        strokeStart.autoreverses = true
        strokeStart.duration = animationDuration
        strokeStart.repeatCount = Float.infinity
        strokeStart.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.fromValue = 1.0
        strokeEnd.toValue = 0.5
        strokeEnd.autoreverses = true
        strokeEnd.duration = animationDuration
        strokeEnd.repeatCount = Float.infinity
        strokeEnd.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let fade = CABasicAnimation(keyPath: "lineWidth")
        fade.fromValue = lineWidth
        fade.toValue = 0.0
        fade.duration = animationDuration
        fade.autoreverses = true
        fade.repeatCount = Float.infinity
        fade.timingFunction = CAMediaTimingFunction(controlPoints: 0.55, 0.0, 0.45, 1.0)
        
        replicatorLayer.add(rotate, forKey: "rotate")
        self.add(rotate, forKey: "rotate")
        segmentLayer.add(strokeStart, forKey: "start")
        segmentLayer.add(strokeEnd, forKey: "end")
        segmentLayer.add(fade, forKey: "fade")
    }
    
    func stopAnimation() {
        isAnimating = false
        replicatorLayer.removeAnimation(forKey: "rotate")
        segmentLayer.removeAnimation(forKey: "start")
        self.removeAnimation(forKey: "rotate")
        segmentLayer.removeAnimation(forKey: "end")
        segmentLayer.removeAnimation(forKey: "fade")
    }
}
