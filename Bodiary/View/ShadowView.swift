//
//  ShadowView.swift
//  Bodiary
//
//  Created by 김진선 on 2017. 11. 8..
//  Copyright © 2017년 김진선. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        self.layer.shadowColor = #colorLiteral(red: 0.2549019608, green: 0.2705882353, blue: 0.3137254902, alpha: 1)
        
    }

}
