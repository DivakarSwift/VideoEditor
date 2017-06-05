//
//  THTitleLayer.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import CoreMedia
import CoreGraphics

class THTitleLayer: THCompositionLayer {
    var titleImage: UIImage?
    var titleText: String?
    var subtitleText: String?
    var useLargeFont: Bool?
    var spinOut: Bool?
    
    override func layer() -> CALayer? {
        let titleLayer = CALayer()
        titleLayer.bounds = CGRect(x: 0, y: 0, width: 1280, height: 400)
        
        if let titleImage = self.titleImage {
            let imageLayer = CALayer()
            let logoImage = titleImage
            imageLayer.bounds = CGRect(x: 0, y: 0, width: (logoImage.size.width), height: (logoImage.size.height))
            imageLayer.position = CGPoint(x: titleLayer.bounds.midX - 20, y: 100)
            imageLayer.contents = logoImage.cgImage
            titleLayer.addSublayer(imageLayer)
        }
        
        let fontSize: CGFloat = self.useLargeFont! ? 64.0: 54.0
        let titleTextLayer = CATextLayer()
        titleTextLayer.string = self.titleText!
        let fontRef = CTFontCreateWithName("GillSans-Bold" as CFString, fontSize, nil)
        titleTextLayer.font = fontRef
        titleTextLayer.fontSize = fontSize
        let font = UIFont(name: "GillSans-Bold", size: fontSize)
        let textSize = (self.titleText! as NSString).size(attributes: [NSFontAttributeName : font!])
        
        titleTextLayer.bounds = CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height)
        titleTextLayer.position = CGPoint(x: titleLayer.bounds.midX, y: 300)
        titleTextLayer.backgroundColor = UIColor.clear.cgColor
        
        titleLayer.addSublayer(titleTextLayer)
        
        titleLayer.opacity = 0.0
        
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0.0
        fadeInAnimation.toValue = 1.0
        fadeInAnimation.isAdditive = false
        fadeInAnimation.isRemovedOnCompletion = false
        fadeInAnimation.beginTime = CMTimeGetSeconds(self.startTimeInTimeLine)
        fadeInAnimation.duration = 1.0
        fadeInAnimation.autoreverses = false
        fadeInAnimation.fillMode = kCAFillModeBoth
        
        titleLayer.add(fadeInAnimation, forKey: nil)
        
        let animatedOutStartTime = CMTimeAdd(self.startTimeInTimeLine, self.timeRange.duration)
        
        if self.spinOut! {
            let outAnimation = CABasicAnimation(keyPath: "opacity")
            outAnimation.fromValue = 1.0
            outAnimation.toValue = 0.0
            outAnimation.isAdditive = false
            outAnimation.isRemovedOnCompletion = false
            outAnimation.beginTime = CMTimeGetSeconds(animatedOutStartTime)
            outAnimation.duration = 1.0
            outAnimation.autoreverses = false
            outAnimation.fillMode = kCAFillModeForwards
            
            titleLayer.add(outAnimation, forKey: nil)
        }
        else {
            let rotationAnimation = CABasicAnimation(keyPath: "transfrom.ratation.z")
            rotationAnimation.toValue = (2 * Double.pi) * -2
            rotationAnimation.duration = 3.0
            rotationAnimation.beginTime = CMTimeGetSeconds(animatedOutStartTime)
            rotationAnimation.isRemovedOnCompletion = false
            rotationAnimation.autoreverses = false
            rotationAnimation.fillMode = kCAFillModeForwards
            rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 1.0
            scaleAnimation.toValue = 0.0
            scaleAnimation.duration = 0.8
            scaleAnimation.beginTime = CMTimeGetSeconds(animatedOutStartTime)
            scaleAnimation.isRemovedOnCompletion = false
            scaleAnimation.autoreverses = false
            scaleAnimation.fillMode = kCAFillModeForwards
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            let animationGroup = CAAnimationGroup()
            animationGroup.isRemovedOnCompletion = false
            animationGroup.fillMode = kCAFillModeForwards
            animationGroup.autoreverses = false
            animationGroup.beginTime = CMTimeGetSeconds(animatedOutStartTime)
            animationGroup.animations = [rotationAnimation, scaleAnimation]
            
            titleLayer.add(rotationAnimation, forKey: "spinOut")
            titleLayer.add(scaleAnimation, forKey: "scaleOut")
        }
        
        return titleLayer
    }
}
