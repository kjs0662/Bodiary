//
//  RoundedImage.swift
//  Bodiary
//
//  Created by 김진선 on 2017. 10. 27..
//  Copyright © 2017년 김진선. All rights reserved.
//

import UIKit

class RoundedImage: UIImageView {

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
}

