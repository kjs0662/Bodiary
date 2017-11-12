//
//  CreateBodiaryVC.swift
//  Bodiary
//
//  Created by 김진선 on 2017. 10. 24..
//  Copyright © 2017년 김진선. All rights reserved.
//

import UIKit
import CoreData
import JTAppleCalendar


class CreateBodiaryVC: UIViewController {
    
    // Outlets
    
    @IBOutlet weak var newImageView: UIImageView!
    @IBOutlet weak var diaryTextView: UITextView!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!

    
    
    
    // Properties
    
    var passedImage:UIImage!
    var passedDate:String!
    var changedDate:String!
    
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        newImageView.image = passedImage
        diaryTextView.delegate = self
        changeDateFormatt()
        todayLabel.text = changedDate
        // Do any additional setup after loading the view.
    }
    
    func changeDateFormatt() {
        formatter.dateFormat = "yyyy MM dd"
        let date = formatter.date(from: passedDate)
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date!)
        formatter.dateFormat = "MM"
        let month = formatter.string(from: date!)
        formatter.dateFormat = "dd"
        let day = formatter.string(from: date!)
        changedDate = "\(year)년 \(month)월 \(day)일"
    }
    
    func initData(fromImage image: UIImage, forDate date: String) {
        self.passedImage = image
        self.passedDate = date
    }

    @IBAction func confirmBtnPressed(_ sender: Any) {
        if diaryTextView.text == "" || diaryTextView.text == "다이어리 입력..." {
            diaryTextView.text = "No Pain, No Gain"
        }
        if weightTextField.text == "" {
            weightTextField.text = "0"
        }
        saveObjects()
        guard let calendarVC = storyboard?.instantiateViewController(withIdentifier: "CalendarVC") as? CalendarVC else { return }
        present(calendarVC, animated: true, completion: nil)
        print("save new bodiary!")
    }
    
    func saveObjects() {
        saveBodiary { (complete) in
            if complete {
                
            }
        }

    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateBodiaryVC {
    func saveBodiary(completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let bodiary = Bodiary(context: managedContext)
        bodiary.image = NSData(data: UIImageJPEGRepresentation(self.newImageView.image!, 0.3)!) as Data
        bodiary.diary = diaryTextView.text
        bodiary.date = passedDate
        bodiary.weight = Int32(weightTextField.text!)!
        
        do {
            try managedContext.save()
            completion(true)
        } catch {
            completion(false)
            debugPrint(error.localizedDescription)
        }
    }
}

extension CreateBodiaryVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        diaryTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}

