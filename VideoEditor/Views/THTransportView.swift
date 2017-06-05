//
//  THTransportView.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

class THTransportView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        var rect = self.bounds
        rect.origin.x = 0
        let imageView = UIImageView(frame: rect)
        imageView.image = #imageLiteral(resourceName: "tb_background").resizableImage(withCapInsets: UIEdgeInsetsMake(0, 3, 0, 3))
        self.addSubview(imageView)
        self.sendSubview(toBack: imageView)
    }
}
