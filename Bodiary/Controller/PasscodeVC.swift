//
//  PasscodeVC.swift
//  Bodiary
//
//  Created by 김진선 on 2017. 11. 5..
//  Copyright © 2017년 김진선. All rights reserved.
//

import UIKit
import CoreData

class PasscodeVC: UIViewController {
    
    // Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var passcodeView:Array<UIView>!
    @IBOutlet weak var passcodeContainerView: UIView!
    
    let numberArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", "D"]
    var passcodeArray:[String] = []
    var tempPasscodeArray:[String] = []
    var passcode:[Passcode] = []
    var stringPasscode:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchPasscode()
        setUpView()
        
        // Do any additional setup after loading the view.
    }
    
    
}

extension PasscodeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "passcodeCell", for: indexPath) as? PasscodeCell else { return UICollectionViewCell() }
        if numberArray[indexPath.row] == "D" {
            cell.numberLabel.isHidden = true
            cell.imageView.isHidden = false
        } else {
            cell.numberLabel.text = numberArray[indexPath.row]
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let number = numberArray[indexPath.row]
        if number != "" && number != "D" {
            passcodeArray.append(number)
        } else if number == "D" {
            if passcodeArray.count > 0 {
                passcodeArray.remove(at: passcodeArray.count - 1)
            }
        }
        switch passcodeArray.count {
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
            
            stringPasscode = passcodeArray[0] + passcodeArray[1] + passcodeArray[2] + passcodeArray[3]
            
            checkPasscode()
        default:
            return
        }
    }
    
    func checkPasscode() {
        if stringPasscode == passcode[0].passcode {
            guard let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else { return }
            present(homeVC, animated: false, completion: nil)
        } else {
            passcodeContainerView.wiggle()
            subTitleLabel.text = "암호가 일치하지 않습니다."
            passcodeView[0].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passcodeView[1].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passcodeView[2].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passcodeView[3].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passcodeArray.removeAll()
        }
    }
    
    func setUpView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 2, height: UIScreen.main.bounds.width/5 - 2)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        collectionView.collectionViewLayout = layout
    }
}

extension PasscodeVC {
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
