//
//  THPlaybackView.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import AVFoundation

class THPlaybackView: UIView {
    
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    var player: AVPlayer {
        get {
            return ((self.layer as? AVPlayerLayer)?.player)!
        }
        set(player) {
            (self.layer as! AVPlayerLayer).videoGravity = AVLayerVideoGravityResizeAspectFill
            (self.layer as! AVPlayerLayer).player = player
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.black
    }
}
