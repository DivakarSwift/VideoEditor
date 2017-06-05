//
//  THView.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

extension UIView {
    
    func frameX() -> CGFloat {
        return self.frame.origin.x
    }
    
    func setFrameX(newX: CGFloat) {
        self.frame = CGRect(x: newX, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    func frameY() -> CGFloat {
        return self.frame.origin.y
    }
    
    func setFrameY(newY: CGFloat) {
        self.frame = CGRect(x: self.frame.origin.x, y: newY, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    func frameWidth() -> CGFloat {
        return self.frame.width
    }
    
    func setFrameWidth(newWidth: CGFloat) {
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newWidth, height: self.frame.size.height)
    }
    
    func frameHeight() -> CGFloat {
        return self.frame.height
    }
    
    func setFrameHeight(newHeight: CGFloat) {
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: newHeight)
    }
    
    func frameOrigin() -> CGPoint {
        return self.frame.origin
    }
    
    func setFrameOrigin(newOrigin: CGPoint) {
        self.frame = CGRect(x: newOrigin.x, y: newOrigin.y, width: self.frame.width, height: self.frame.size.height)
    }
    
    func frameSize() -> CGSize {
        return self.frame.size
    }
    
    func setFrameSize(newSize: CGSize) {
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newSize.width, height: newSize.height)
    }
    
    func boundsX() -> CGFloat {
        return self.bounds.origin.x
    }
    
    func setBoundsX(newX: CGFloat) {
        self.bounds = CGRect(x: newX, y: self.bounds.origin.y, width: self.bounds.width, height: self.bounds.height)
    }
    
    func boundsY() -> CGFloat {
        return self.bounds.origin.y
    }
    
    func setBoundsY(newY: CGFloat) {
        self.bounds = CGRect(x: self.bounds.origin.x, y: newY, width: self.bounds.width, height: self.bounds.height)
    }
    
    func boundsWidth() -> CGFloat {
        return self.bounds.width
    }
    
    func setBoundsWidth(newWidth: CGFloat) {
        self.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: newWidth, height: self.bounds.height)
    }
    
    func boundsHeight() -> CGFloat {
        return self.bounds.height
    }
    
    func setBoundsHeight(newHeight: CGFloat) {
        self.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.width, height: newHeight)
    }
    
    func centerX() -> CGFloat {
        return self.center.x
    }
    
    func setCenterX(newX: CGFloat) {
        self.center = CGPoint(x: newX, y: self.center.y)
    }
    
    func centerY() -> CGFloat {
        return self.center.y
    }
    
    func setCenterY(newY: CGFloat) {
        self.center = CGPoint(x: self.center.x, y: newY)
    }
    
    // Screen Shotting Methods
    
    func toImage() -> UIImage {
        return self.toImageWithSize(size: self.bounds.size)
    }
    
    func toImageWithSize(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func toImageView() -> UIImageView {
        return self.toImageViewWithSize(size: self.bounds.size)
    }
    
    func toImageViewWithSize(size: CGSize) -> UIImageView {
        let imageView = UIImageView(image: self.toImageWithSize(size: size))
        imageView.frame = CGRect(x: self.frameX(), y: self.frameY(), width: self.frameWidth(), height: self.frameHeight())
        return imageView
    }

}
