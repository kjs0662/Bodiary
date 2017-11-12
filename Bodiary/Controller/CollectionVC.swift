//
//  CollectionVC.swift
//  Bodiary
//
//  Created by 김진선 on 2017. 10. 30..
//  Copyright © 2017년 김진선. All rights reserved.
//

import UIKit
import CoreData

class CollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let formatter = DateFormatter()
    
    var bodiaries:[Bodiary] = []
    var selectedDate = ""
    var dateStringArray:[String] = []
    var dateArray:[Date] = []
    var sortedArray:[Date] = []
    var sortedDateStringArray:[String] = []
    var dateIndex:Int!
    var sortedBodiaries:[Bodiary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchBodiaryData()
        setToday()
        setUpView()
        if bodiaries.count > 0 {
            for i in 0 ..< self.bodiaries.count {
                self.dateStringArray.append(self.bodiaries[i].date!)
            }
            sortedByDate()
            sortBodiaryByDate()
        }
        scrollToBottom()



        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func scrollToBottom() {
        let lastIndex = IndexPath(item: sortedBodiaries.count - 1, section: 0)
        if sortedBodiaries.count > 0 {
            collectionView.scrollToItem(at: lastIndex, at: .bottom, animated: false)
        }
    }
    
    func setToday() {
        formatter.dateFormat = "yyyy MM dd"
        let today = Date()
        let todayString = formatter.string(from: today)
        selectedDate = todayString
    }
    
    func sortedByDate() {
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
        print(sortedDateStringArray)
    }

    func sortBodiaryByDate() {
        for i in 0 ..< sortedDateStringArray.count {
            for j in 0 ..< bodiaries.count {
                if sortedDateStringArray[i] == bodiaries[j].date! {
                    sortedBodiaries.append(bodiaries[j])
                }

            }
        }
    }
    
    func fetchBodiaryData() {
        fetchBodiary { (success) in
            if success {
                print("fetched bodiary data!")
            }
        }
    }
    
    @IBAction func homeBtnPressed(_ sender: Any) {
        guard let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else { return }
        present(homeVC, animated: false, completion: nil)
    }
    
    @IBAction func calendarBtnPressed(_ sender: Any) {
        guard let calendarVC = storyboard?.instantiateViewController(withIdentifier: "CalendarVC") as? CalendarVC else { return }
        present(calendarVC, animated: false, completion: nil)
    }
    
    @IBAction func settingBtnPressed(_ sender: Any) {
        guard let configurationVC = storyboard?.instantiateViewController(withIdentifier: "ConfigurationVC") as? ConfigurationVC else {
            return
        }
        present(configurationVC, animated: false, completion: nil)
    }
    
    
    func setUpView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 2, height: UIScreen.main.bounds.width/3 - 1)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        collectionView.collectionViewLayout = layout
    }
    
    // CollectionView
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }

        let body = sortedBodiaries[indexPath.row]
        
        formatter.dateFormat = "yyyy MM dd"
        
        cell.configureCell(forImage: UIImage(data: body.image!)!, forDate: body.date!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedBodiaries.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let collectionDetailVC = storyboard?.instantiateViewController(withIdentifier: "CollectionDetailVC") as? CollectionDetailVC else { return }
        
        let body = sortedBodiaries[indexPath.row]
        collectionDetailVC.initData(forImage: UIImage(data: body.image!)!, forDiary: body.diary!, forDate: body.date!, forWeight: String(describing: body.weight))
        self.presentDetail(collectionDetailVC)
    }


}

extension CollectionVC {
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
}


