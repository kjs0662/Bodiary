//
//  ExerciseInfoCell.swift
//  Bodiary
//
//  Created by 김진선 on 2017. 10. 27..
//  Copyright © 2017년 김진선. All rights reserved.
//

import UIKit

class ExerciseInfoCell: UITableViewCell {
    
    // Outlets
    
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var exerciseDescLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
