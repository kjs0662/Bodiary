//
//  HomeVC.swift
//  Bodiary
//
//  Created by 김진선 on 2017. 10. 18..
//  Copyright © 2017년 김진선. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class HomeVC: UIViewController {
    
    // Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var beforeImage: UIImageView!
    @IBOutlet weak var afterImage: UIImageView!
    @IBOutlet weak var beforeDateLabel: UILabel!
    @IBOutlet weak var afterDateLabel: UILabel!
    
    var goals : [WeeklyGoal] = []
    var bodiaries : [Bodiary] = []
    var dateStringArray:[String] = []
    var dateArray:[Date] = []
    var sortedArray:[Date] = []
    var sortedDateStringArray:[String] = []
    var firstIndex:Int!
    var lastIndex:Int!
    
    
    let formatter = DateFormatter()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchCoreDataObjects()
        if bodiaries.count > 0 {
            for i in 0 ..< self.bodiaries.count {
                self.dateStringArray.append(self.bodiaries[i].date!)
            }
            sortedByDate()
            setUpView()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()

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
    
    func fetchCoreDataObjects() {
        self.fetchGoals { (complete) in
            if complete {
                print("You fetched goals data")
            }
        }
        self.fetchBodiary { (complete) in
            if complete {
                print("fetched bodiary data")
            }
        }
    }
    
    func setUpView() {
        for i in 0 ..< bodiaries.count {
            if bodiaries[i].date! == sortedDateStringArray[0] {
                firstIndex = i
                }
            if bodiaries[i].date! == sortedDateStringArray[sortedDateStringArray.count - 1] {
                lastIndex = i
            }
        }

        let first = bodiaries[firstIndex]
        let last = bodiaries[lastIndex]
        
        self.beforeImage.image = UIImage(data: first.image!)
        self.afterImage.image = UIImage(data: last.image!)
        self.beforeDateLabel.text = first.date
        self.afterDateLabel.text = last.date
    }
    
    // Footer Buttons pressed
    
    @IBAction func calendarBtnPressed(_ sender: Any) {
        
        guard let calendarVC = storyboard?.instantiateViewController(withIdentifier: "CalendarVC") as? CalendarVC else { return }
        present(calendarVC, animated: false, completion: nil)
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        guard let setWeeklyPlanVC = storyboard?.instantiateViewController(withIdentifier: "SetWeeklyPlanVC") as? SetWeeklyPlanVC else { return }
        
        present(setWeeklyPlanVC, animated: true, completion: nil)
    }
    
    @IBAction func collectionViewBtnPressed(_ sender: Any) {
        guard let collectionVC = storyboard?.instantiateViewController(withIdentifier: "CollectionVC") as? CollectionVC else { return }
        present(collectionVC, animated: false, completion: nil)
    }
    
    @IBAction func goToConfigurationViewBtnPressed(_ sender: Any) {
        guard let configurationVC = storyboard?.instantiateViewController(withIdentifier: "ConfigurationVC") as? ConfigurationVC else {
            return
        }
        present(configurationVC, animated: false, completion: nil)
    }
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weeklyGoalsCell") as? WeeklyGoalsCell else { return UITableViewCell() }
        fetchCoreDataObjects()
        let goal = goals[indexPath.row]
        cell.configureCell(weeklyGoal: goal)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setProgress(atIndexPath: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "삭제") { (rowAction, indexPath) in
            self.removeGoal(atIndexPath: indexPath)
            self.fetchCoreDataObjects()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        return [deleteAction]
    }
    
    

}

extension HomeVC {
     func setProgress(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let chosenGoal = goals[indexPath.row]
        
        if chosenGoal.goalProgress < chosenGoal.repeatValue {
            chosenGoal.goalProgress = chosenGoal.goalProgress + 1
        } else {
            return
        }
        
        do {
            try managedContext.save()
            print("Successfully set progress!")
        } catch {
            debugPrint("Could not set progress: \(error.localizedDescription)")
        }
    }
    
    func fetchGoals(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<WeeklyGoal>(entityName: "WeeklyGoal")
        
        do {
            goals = try managedContext.fetch(fetchRequest)
            print("Successfully Fetched")
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    func removeGoal(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        managedContext.delete(goals[indexPath.row])
        
        do {
            try managedContext.save()
            print("Successfully removed goal!")
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
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
