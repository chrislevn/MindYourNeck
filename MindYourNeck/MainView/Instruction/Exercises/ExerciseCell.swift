//
//  ExerciseCell.swift
//  MindYourNeck
//
//  Created by Hong Loc on 9/13/18.
//  Copyright © 2018 Hong Loc. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell {

    @IBOutlet weak var StepLabel: UILabel!
    @IBOutlet weak var ContentLabel: UITextView!
    @IBOutlet weak var ImageLabel: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
