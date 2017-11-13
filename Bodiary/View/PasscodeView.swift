//
//  PasscodeView.swift
//  Bodiary
//
//  Created by 김진선 on 2017. 11. 14..
//  Copyright © 2017년 김진선. All rights reserved.
//

import UIKit
import CoreData

class PasscodeView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var passcodeContainerView: UIView!
    @IBOutlet var passcodeView:Array<UIView>!
    @IBOutlet var numberBtn:Array<UIButton>!
    
    var inputCode:[String] = []
    var stringPasscode:String!
    var passcode:[Passcode] = []
    
    @IBAction func numberBtnPressed(_ sender: UIButton) {
        inputCode.append(sender.currentTitle!)
        
        switch inputCode.count {
        case 0:
            passcodeView[0].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passcodeView[1].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passcodeView[2].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passcodeView[3].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case 1:
            passcodeView[0].backgroundColor = #colorLiteral(red: 1, green: 0.3795550466, blue: 0.5373343229, alpha: 1)
            passcodeView[1].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passcodeView[2].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passcodeView[3].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case 2:
            passcodeView[0].backgroundColor = #colorLiteral(red: 1, green: 0.3795550466, blue: 0.5373343229, alpha: 1)
            passcodeView[1].backgroundColor = #colorLiteral(red: 1, green: 0.3795550466, blue: 0.5373343229, alpha: 1)
            passcodeView[2].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passcodeView[3].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case 3:
            passcodeView[0].backgroundColor = #colorLiteral(red: 1, green: 0.3795550466, blue: 0.5373343229, alpha: 1)
            passcodeView[1].backgroundColor = #colorLiteral(red: 1, green: 0.3795550466, blue: 0.5373343229, alpha: 1)
            passcodeView[2].backgroundColor = #colorLiteral(red: 1, green: 0.3795550466, blue: 0.5373343229, alpha: 1)
            passcodeView[3].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case 4:
            
            passcodeView[0].backgroundColor = #colorLiteral(red: 1, green: 0.3795550466, blue: 0.5373343229, alpha: 1)
            passcodeView[1].backgroundColor = #colorLiteral(red: 1, green: 0.3795550466, blue: 0.5373343229, alpha: 1)
            passcodeView[2].backgroundColor = #colorLiteral(red: 1, green: 0.3795550466, blue: 0.5373343229, alpha: 1)
            passcodeView[3].backgroundColor = #colorLiteral(red: 1, green: 0.3795550466, blue: 0.5373343229, alpha: 1)
            
            stringPasscode = inputCode[0] + inputCode[1] + inputCode[2] + inputCode[3]
            fetchPasscode()
            checkPasscode()

        default:
            return
        }
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        if inputCode.count > 0 {
            inputCode.remove(at: inputCode.count - 1)
        }
        switch inputCode.count {
        case 0:
            passcodeView[0].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passcodeView[1].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passcodeView[2].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passcodeView[3].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case 1:
            passcodeView[0].backgroundColor = #colorLiteral(red: 1, green: 0.3803921569, blue: 0.537254902, alpha: 1)
            passcodeView[1].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passcodeView[2].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passcodeView[3].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case 2:
            passcodeView[0].backgroundColor = #colorLiteral(red: 1, green: 0.3795550466, blue: 0.5373343229, alpha: 1)
            passcodeView[1].backgroundColor = #colorLiteral(red: 1, green: 0.3795550466, blue: 0.5373343229, alpha: 1)
            passcodeView[2].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passcodeView[3].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case 3:
            passcodeView[0].backgroundColor = #colorLiteral(red: 1, green: 0.3795550466, blue: 0.5373343229, alpha: 1)
            passcodeView[1].backgroundColor = #colorLiteral(red: 1, green: 0.3795550466, blue: 0.5373343229, alpha: 1)
            passcodeView[2].backgroundColor = #colorLiteral(red: 1, green: 0.3795550466, blue: 0.5373343229, alpha: 1)
            passcodeView[3].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        default:
            return
        }
    }
    
    func checkPasscode() {
        if stringPasscode == passcode[0].passcode {
            dispatchPasscode = .logIn
            removeFromSuperview()
        } else {
            passcodeContainerView.wiggle()
            subTitleLabel.text = "암호가 일치하지 않습니다."
            passcodeView[0].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passcodeView[1].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passcodeView[2].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passcodeView[3].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            inputCode.removeAll()
        }
    }
    
}

extension PasscodeView {
    func fetchPasscode() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<Passcode>(entityName: "Passcode")
        do {
            passcode = try managedContext.fetch(fetchRequest)
            print("fetched passcode")
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
