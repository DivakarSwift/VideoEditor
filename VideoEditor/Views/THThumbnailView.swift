//
//  THThumbnailView.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

let THUMBNAIL_SIZE = CGSize(width: 113.0, height: 64.0)

class THThumbnailView: UIView {

    var thumbnails: [UIImage]?
    
    func setThumbnails(thumbnails: [UIImage]) {
        self.thumbnails = thumbnails
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        var xPos:CGFloat = 0.0
        let width = self.frame.width / CGFloat(THUMBNAIL_COUNT)
        for image in self.thumbnails! {
            image.draw(in: CGRect(x: xPos, y: 0.0, width: width, height: THUMBNAIL_SIZE.height))
            xPos = xPos + width
        }
    }

}
