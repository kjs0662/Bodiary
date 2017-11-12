//
//  ConfigurationVC.swift
//  Bodiary
//
//  Created by 김진선 on 2017. 10. 31..
//  Copyright © 2017년 김진선. All rights reserved.
//

import UIKit
import CoreData

class ConfigurationVC: UIViewController {
    
    // Outlets
    
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var beforeImage: UIImageView!
    @IBOutlet weak var afterImage: UIImageView!
    
    var bodiaries:[Bodiary] = []
    var passcode = ""
    
    var dateStringArray:[String] = []
    var dateArray:[Date] = []
    var sortedArray:[Date] = []
    var sortedDateStringArray:[String] = []
    var firstIndex:Int!
    var lastIndex:Int!
    
    let formatter = DateFormatter()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchBodiary { (complete) in
            if complete {
                print("fetched data!!")
            }
        }

        setUpImage()

    }
    
    func setUpImage() {
        if bodiaries.count > 0 {
            for i in 0 ..< bodiaries.count {
                self.dateStringArray.append(bodiaries[i].date!)
            }
            formatter.dateFormat = "yyyy MM dd"
            for i in dateStringArray {
                let date = formatter.date(from: i)
                dateArray.append(date!)
            }
            sortedArray = dateArray.sorted(by: { $0.compare($1) == .orderedAscending })
            
            for i in sortedArray {
                let date = formatter.string(from: i)
                sortedDateStringArray.append(date)
            }
        }
        if bodiaries.count > 0 {
            for i in 0 ..< bodiaries.count {
                if bodiaries[i].date! == sortedDateStringArray[0] {
                    firstIndex = i
                }
                if bodiaries[i].date! == sortedDateStringArray[sortedDateStringArray.count - 1] {
                    lastIndex = i
                }
            }
        }
        if bodiaries.count > 0 {
//            let first = bodiaries[firstIndex]
            let last = bodiaries[lastIndex]
//            self.beforeImage.image = UIImage(data: first.image!)!
            self.afterImage.image = UIImage(data: last.image!)!
        }
        
        totalCountLabel.text = "지금까지 총 \(bodiaries.count)번의 Body Diary가 있습니다!"
    }

    @IBAction func setPasscodeBtnPressed(_ sender: Any) {
        guard let createPasscodeVC = storyboard?.instantiateViewController(withIdentifier: "CreatePasscodeVC") as? CreatePasscodeVC else { return }
        present(createPasscodeVC, animated: false, completion: nil)
    }
    
    @IBAction func deleteAllBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: "저장된 모든 데이터가 삭제됩니다.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "삭제", style: .destructive) { (action: UIAlertAction) in
            self.removeAllBodiary()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(alertAction)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func homeVCBtnPressed(_ sender: Any) {
        guard let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else { return }
        present(homeVC, animated: false, completion: nil)
    }
    
    @IBAction func calendarVCBtnPressed(_ sender: Any) {
        guard let calendarVC = storyboard?.instantiateViewController(withIdentifier: "CalendarVC") as? CalendarVC else { return }
        present(calendarVC, animated: false, completion: nil)
    }
    
    @IBAction func collectionVCBtnPressed(_ sender: Any) {
        guard let collectionVC = storyboard?.instantiateViewController(withIdentifier: "CollectionVC") as? CollectionVC else { return }
        present(collectionVC, animated: false, completion: nil)
    }
    
}

extension ConfigurationVC {
    func fetchBodiary(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<Bodiary>(entityName: "Bodiary")
        
        do {
            bodiaries = try managedContext.fetch(fetchRequest)
            print("Successfully Fetched")
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    func removeAllBodiary() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        for i in 0 ..< bodiaries.count {
            managedContext.delete(bodiaries[i])
        }
        
        do {
            try managedContext.save()
            print("Successfully removed all bodiary data!")
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }

    }
    
}
