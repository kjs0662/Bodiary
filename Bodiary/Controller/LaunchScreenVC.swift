//
//  LaunchScreenVC.swift
//  Bodiary
//
//  Created by 김진선 on 2017. 11. 4..
//  Copyright © 2017년 김진선. All rights reserved.
//

import UIKit
import CoreData

class LaunchScreenVC: UIViewController {
    
    var passcode:[Passcode] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPasscode()
        if passcode.count == 0 {
            perform(#selector(goToHomeVC), with: nil, afterDelay: 1)
        } else {
            perform(#selector(goToPasscodeVC), with: nil, afterDelay: 1)
        }

        // Do any additional setup after loading the view.
    }
    
    @objc func goToHomeVC() {
        guard let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else { return }
        present(homeVC, animated: false, completion: nil)

    }
    
    @objc func goToPasscodeVC() {
        guard let passcodeVC = storyboard?.instantiateViewController(withIdentifier: "PasscodeVC") as? PasscodeVC else { return }
        present(passcodeVC, animated: false, completion: nil)
    }


}
extension LaunchScreenVC {
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
