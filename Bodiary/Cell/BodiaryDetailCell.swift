//
//  BodiaryDetailCell.swift
//  Bodiary
//
//  Created by 김진선 on 2017. 10. 24..
//  Copyright © 2017년 김진선. All rights reserved.
//

import UIKit

class BodiaryDetailCell: UITableViewCell {
    
    // Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
