//
//  DDProgressView.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

let kProgressBarheight:CGFloat = 22.0
let kProgressBarWidth:CGFloat = 160.0

class DDProgressView: UIView {

    var innerColor: UIColor = UIColor(white: 0.906, alpha: 1.000)
    var outerColor: UIColor = UIColor(white: 0.906, alpha: 1.000)
    var emptyColor: UIColor = UIColor.clear
    fileprivate var progress: Float = 0.0
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set(newFrame) {
            var frame = newFrame
            frame.size.height = kProgressBarheight
            super.frame = frame
        }
    }
//    func setFrame(newFrame: CGRect) {
//        var frame = newFrame
//        frame.size.height = kProgressBarheight
//        self.frame = frame
//    }
    
    override var bounds: CGRect {
        get {
            return super.bounds
        }
        set(newBounds) {
            var bounds = newBounds
            bounds.size.height = kProgressBarheight
            super.bounds = bounds
        }
    }
//    func setBounds(newBounds: CGRect) {
//        var bounds = newBounds
//        bounds.size.height = kProgressBarheight
//        self.bounds = bounds
//    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        if self.frame.width == 0.0 {
            self.setFrameX(newX: kProgressBarWidth)
        }
    }
    
    func setProgress(progress: Float) {
        var progress = progress
        if progress > 1.0 {
            progress = 1.0
        }
        else if progress < 0.0 {
            progress = 0.0
        }
        self.progress = progress
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.setAllowsAntialiasing(true)
        
        var rect = rect
        rect = rect.insetBy(dx: 1.0, dy: 1.0)
        var radius = rect.size.height * 0.5
        
        self.outerColor.setStroke()
        context?.beginPath()
        context?.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context?.addArc(tangent1End: CGPoint(x: rect.minY, y: rect.minY), tangent2End: CGPoint(x: rect.midX, y: rect.minY), radius: radius)
        context?.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.minY), tangent2End: CGPoint(x: rect.maxX, y: rect.midY), radius: radius)
        context?.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.maxY), tangent2End: CGPoint(x: rect.midX, y: rect.maxY), radius: radius)
        context?.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.maxY), tangent2End: CGPoint(x: rect.minX, y: rect.midY), radius: radius)
        context?.closePath()
        context?.drawPath(using: .stroke)
        
        rect = rect.insetBy(dx: 3.0, dy: 3.0)
        radius = rect.size.height * 0.5
        
        self.emptyColor.setFill()
        
        context?.beginPath()
        context?.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context?.addArc(tangent1End: CGPoint(x: rect.minY, y: rect.minY), tangent2End: CGPoint(x: rect.midX, y: rect.minY), radius: radius)
        context?.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.minY), tangent2End: CGPoint(x: rect.maxX, y: rect.midY), radius: radius)
        context?.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.maxY), tangent2End: CGPoint(x: rect.midX, y: rect.maxY), radius: radius)
        context?.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.maxY), tangent2End: CGPoint(x: rect.minX, y: rect.midY), radius: radius)
        context?.closePath()
        context?.fillPath()
        
        radius = rect.size.height * 0.5
        rect.size.width = CGFloat(self.progress)
        if rect.size.width < radius * 2 {
            rect.size.width = 2 * radius
        }
        
        self.innerColor.setFill()
        
        context?.beginPath()
        context?.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context?.addArc(tangent1End: CGPoint(x: rect.minY, y: rect.minY), tangent2End: CGPoint(x: rect.midX, y: rect.minY), radius: radius)
        context?.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.minY), tangent2End: CGPoint(x: rect.maxX, y: rect.midY), radius: radius)
        context?.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.maxY), tangent2End: CGPoint(x: rect.midX, y: rect.maxY), radius: radius)
        context?.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.maxY), tangent2End: CGPoint(x: rect.minX, y: rect.midY), radius: radius)
        context?.closePath()
        context?.fillPath()
        
        context?.restoreGState()
    }
}
