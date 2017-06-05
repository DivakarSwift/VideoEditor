//
//  THAudioItemTableViewCell.swift
//  VideoEditor
//
//  Created by Mobdev125 on 6/3/17.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

class THAudioItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
