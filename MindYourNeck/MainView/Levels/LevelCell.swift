//
//  LevelCell.swift
//  MindYourNeck
//
//  Created by Hong Loc on 9/13/18.
//  Copyright © 2018 Hong Loc. All rights reserved.
//

import UIKit

class LevelCell: UITableViewCell {

    @IBOutlet weak var medalImage: UIImageView!
    @IBOutlet weak var levelTitle: UILabel!
    @IBOutlet weak var levelDescript: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
