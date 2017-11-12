//
//  SetWeeklyPlanVC.swift
//  Bodiary
//
//  Created by 김진선 on 2017. 10. 18..
//  Copyright © 2017년 김진선. All rights reserved.
//

import UIKit
import CoreData

class SetWeeklyPlanVC: UIViewController, UITextFieldDelegate {
    
    // Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var workOutNumberBtn: UIButton!
    
    @IBOutlet var countPopUpView: UIView!
    @IBOutlet weak var countNumberTextField: UITextField!
    @IBOutlet var superView: UIView!
    @IBOutlet weak var popUpViewConfirmBtn: UIButton!
    
    
    // Variables
    
    var countNumber = "1"
    var choosenDayArray = ["일", "월", "화", "수", "목", "금", "토"]
    var dayArray = ["일", "월", "화", "수", "목", "금", "토"]

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        countNumberTextField.delegate = self
        // Do any additional setup after loading the view.

    }

    @IBAction func workOutNumberBtnPressed(_ sender: Any) {
        countPopUpView.center = CGPoint(x: countPopUpView.frame.size.width / 2, y: countPopUpView.frame.size.height / 2)
        countPopUpView.frame.size.width = UIScreen.main.bounds.width
        countPopUpView.frame.size.height = UIScreen.main.bounds.height
        superView.addSubview(countPopUpView)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        print(countNumber)
    }

    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        if nameTextField.text != "" {
            self.save(completion: { (success) in
                if success {
                    guard let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else { return }
                    present(homeVC, animated: false, completion: nil)
                }
            })
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        popUpViewConfirmBtn.setTitleColor(#colorLiteral(red: 0.3019607843, green: 0.8156862745, blue: 0.8823529412, alpha: 1), for: .normal)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.countNumberTextField.text != "" {
            popUpViewConfirmBtn.setTitleColor(#colorLiteral(red: 0.3019607843, green: 0.8156862745, blue: 0.8823529412, alpha: 1), for: .normal)
        } else {
            popUpViewConfirmBtn.setTitleColor(#colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1), for: .normal)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        nameTextField.delegate = self
        return true
    }
    
    // Count PopView
    
    @IBAction func popUpViewCancelBtnPressed(_ sender: Any) {
        countPopUpView.removeFromSuperview()
    }
    
    @IBAction func popUpViewConfirmBtnPressed(_ sender: Any) {
        if countNumberTextField.text != "" && countNumberTextField.text != "0" {
            countNumber = countNumberTextField.text!
            workOutNumberBtn.setTitle("일주일에 \(countNumber) 번", for: .normal)
            countPopUpView.removeFromSuperview()
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    func save(completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let goal = WeeklyGoal(context: managedContext)
        
        goal.goalName = self.nameTextField.text
        goal.repeatValue = Int32(countNumber)!
        goal.goalProgress = Int32(0)
        
        do {
            try managedContext.save()
            print("Saved in Coredata!")
            completion(true)
        } catch  {
            debugPrint(error.localizedDescription)
            completion(false)
        }
    }
}

