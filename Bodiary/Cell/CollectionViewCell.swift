//
//  CollectionViewCell.swift
//  Bodiary
//
//  Created by 김진선 on 2017. 10. 30..
//  Copyright © 2017년 김진선. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configureCell(forImage image: UIImage, forDate date: String) {
        self.imageView.image = image
        self.dateLabel.text = date
    }
}
