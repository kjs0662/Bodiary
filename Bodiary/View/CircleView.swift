//
//  CircleView.swift
//  Bodiary
//
//  Created by 김진선 on 2017. 11. 4..
//  Copyright © 2017년 김진선. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIView {
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.layer.frame.width / 2
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
}

