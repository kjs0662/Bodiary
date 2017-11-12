//
//  CollectionDetailVC.swift
//  Bodiary
//
//  Created by 김진선 on 2017. 10. 30..
//  Copyright © 2017년 김진선. All rights reserved.
//

import UIKit

class CollectionDetailVC: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var diaryTextView: UITextView!
    @IBOutlet weak var weightLabel: UILabel!
    
    var passedImage:UIImage!
    var passedDiary:String!
    var passedDate:String!
    var passedWeight:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = passedImage
        diaryTextView.text = passedDiary
        dateLabel.text = passedDate
        weightLabel.text = "\(passedWeight!) kg"

        // Do any additional setup after loading the view.
    }
    
    func initData(forImage image:UIImage, forDiary diary:String, forDate date:String, forWeight weight:String) {
        self.passedImage = image
        self.passedDiary = diary
        self.passedDate = date
        self.passedWeight = weight
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismissDetail()
    }
    
}






