//
//  RoundedBoundsView.swift
//  Bodiary
//
//  Created by 김진선 on 2017. 10. 31..
//  Copyright © 2017년 김진선. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedBoundsView: UIView {
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 1.0
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
}



