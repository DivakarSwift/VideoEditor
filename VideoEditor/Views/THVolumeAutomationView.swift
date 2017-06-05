//
//  THVolumeAutomationView.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import CoreMedia
import CoreGraphics

class THVolumeAutomationView: UIView {

    fileprivate var audioRamps: [THVolumeAutomation]?
    func setAudioRamps(audioRamps:[THVolumeAutomation]?) {
        self.audioRamps = audioRamps
        self.setNeedsDisplay()
    }

    fileprivate var duration: CMTime?
    func setDuration(duration: CMTime) {
        self.duration = duration
        self.scaleFactor = self.bounds.size.width / CGFloat(CMTimeGetSeconds(duration))
    }
    
    var scaleFactor: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }

    func THGetWidthForTimeRange(timeRange: CMTimeRange, scaleFactor: CGFloat) -> CGFloat {
        return CGFloat(CMTimeGetSeconds(timeRange.duration)) * scaleFactor
    }
    
    func xForTime(time: CMTime) -> CGFloat {
        let xTime = CMTimeSubtract(self.duration!, CMTimeSubtract(self.duration!, time))
        return CGFloat(CMTimeGetSeconds(xTime)) * self.scaleFactor!
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.translateBy(x: 0.0, y: rect.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        var x: CGFloat = 0.0, y: CGFloat = 0.0
        let rectHeight = rect.height
        let path = CGMutablePath()
        path.move(to: CGPoint(x: x, y: y))
        for automation in self.audioRamps! {
            x = self.xForTime(time: (automation.timeRange?.start)!)
            y = CGFloat(automation.startVolume!) * rectHeight
            path.addLine(to: CGPoint(x: x, y: y))
            
            x = x + THGetWidthForTimeRange(timeRange: automation.timeRange!, scaleFactor: self.scaleFactor!)
            y = CGFloat(automation.endVolume!) * rectHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        context?.setFillColor(UIColor(white: 1.000, alpha: 0.750).cgColor)
        context?.addPath(path)
        context?.drawPath(using: .fill)
    }
}
