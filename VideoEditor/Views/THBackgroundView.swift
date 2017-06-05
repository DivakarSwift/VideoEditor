//
//  THBackgroundView.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/30/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

let VIEW_REGEX = "TH([A-Za-z]+)BackgroundView"
class THBackgroundView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        let className = NSStringFromClass(THBackgroundView.self)
        let colorName = className.stringByMatchingRegex(regex: VIEW_REGEX, capture: 1)?.lowercased()
        let imageName = "app_\(String(describing: colorName))_background"
        let patternImage = UIImage(named: imageName)
        
        let insetRect = CGRect(x: 2.0, y: 2.0, width: (patternImage?.size.width)! - 2, height: (patternImage?.size.height)! - 2)
        let image = patternImage?.cgImage
        image?.cropping(to: insetRect)
        self.backgroundColor = UIColor(patternImage: UIImage(cgImage: image!))
    }

}

extension NSString {
    func stringByMatchingRegex(regex: String, capture: Int) -> String? {
        let expression = try! NSRegularExpression(pattern: regex, options: NSRegularExpression.Options(rawValue: 0))
        let result = expression.firstMatch(in: self as String, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.length))
        if capture < (result?.numberOfRanges)! {
            let range = result?.rangeAt(capture)
            return self.substring(with: range!)
        }
        return nil
    }
}

class THBlackBackgroundView: THBackgroundView {
    
}

class THStoneBackgroundView: THBackgroundView {
    
}

class THSlateBackgroundView: THBackgroundView {
    
}

class THGrayBackgroundView: THBackgroundView {
    
}

class THWhiteBackgroundView: THBackgroundView {
    
}
