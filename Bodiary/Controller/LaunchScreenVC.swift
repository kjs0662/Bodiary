//
//  LaunchScreenVC.swift
//  Bodiary
//
//  Created by 김진선 on 2017. 11. 4..
//  Copyright © 2017년 김진선. All rights reserved.
//

import UIKit

enum passcodeSet {
    case logIn
    case logOut
}

class LaunchScreenVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        perform(#selector(goToHomeVC), with: nil, afterDelay: 1)


        // Do any additional setup after loading the view.
    }
    
    @objc func goToHomeVC() {
        guard let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else { return }
        present(homeVC, animated: false, completion: nil)

    }
}

