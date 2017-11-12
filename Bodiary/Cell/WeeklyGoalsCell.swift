//
//  WeeklyGoals.swift
//  Bodiary
//
//  Created by 김진선 on 2017. 10. 18..
//  Copyright © 2017년 김진선. All rights reserved.
//

import UIKit
import CoreData

class WeeklyGoalsCell: UITableViewCell {
    
    // Outlets
    
    @IBOutlet weak var weelkyGoalTitleLabel: UILabel!
    @IBOutlet weak var weeklyGoalProcessLabel: UILabel!
    @IBOutlet weak var doneImage: UIImageView!
    @IBOutlet weak var completionView: UIView!
    
    let date = Date()
    let calendar = NSCalendar.current
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func changeColor() {
        self.weelkyGoalTitleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.weeklyGoalProcessLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    func configureCell(weeklyGoal:WeeklyGoal) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        self.weelkyGoalTitleLabel.text = weeklyGoal.goalName
        self.weeklyGoalProcessLabel.text = "\(weeklyGoal.goalProgress)/\(String(weeklyGoal.repeatValue))"
        
        let component = calendar.dateComponents([.weekday], from: date)
        
        if weeklyGoal.goalProgress == weeklyGoal.repeatValue {
            doneImage.isHidden = false
            completionView.isHidden = false
            changeColor()
            if component.weekday == 1 {
                weeklyGoal.goalProgress = 0
                do {
                    try managedContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        } else {
            doneImage.isHidden = true
            completionView.isHidden = true
        }
    }

}
