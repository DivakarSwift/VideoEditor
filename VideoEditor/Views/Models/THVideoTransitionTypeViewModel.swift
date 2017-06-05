//
//  THVideoTransitionTypeViewModel.swift
//  VideoEditor
//
//  Created by Mobdev125 on 5/31/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import CoreMedia

class THVideoTransitionTypeViewModel: NSObject {
    var title: String?
    var type: THVideoTransitionType?
    
    static func typeViewModel(withTitle title: String, type: THVideoTransitionType) -> THVideoTransitionTypeViewModel {
        let model = THVideoTransitionTypeViewModel()
        model.title = title
        model.type = type
        return model
    }
}
