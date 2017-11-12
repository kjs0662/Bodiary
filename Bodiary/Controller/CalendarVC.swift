//
//  CalendarVC.swift
//  Bodiary
//
//  Created by 김진선 on 2017. 10. 21..
//  Copyright © 2017년 김진선. All rights reserved.
//

import UIKit
import JTAppleCalendar
import CoreData

class CalendarVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    // Outlets
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var yearAndMonthLabel: UILabel!
    @IBOutlet weak var goalTitleLabel: UILabel!
    
    // delete 파일명이나 파일이 변경될시 addBtnPressed 액션   func 수정 요망!!!!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var bodyImageView: UIImageView!
    @IBOutlet weak var bodyDescTextView: UITextView!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var exerciseInfoView: UIView!
    @IBOutlet weak var swipeUpConstraint: NSLayoutConstraint!
    
    
    let formatter = DateFormatter()
    let monthColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
    let outSideMonthColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    let selectedMonthColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var selectedDate = ""
    let today = Date()
    var bodiaries:[Bodiary] = []
    var eventsFromCoreData:[String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpCalendarView()
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
        fetchData()
        setUpEventArray()
        setUpCell()

        
        if UIDevice.current.userInterfaceIdiom == .pad {
            swipeUpConstraint.constant = 800

        } else {
            swipeUpConstraint.constant = 90 + 250
        }


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarView.reloadData()
        if UIDevice.current.userInterfaceIdiom != .pad {
            swipeUp()
            swipeDown()
        }
    }
    
    func setUpCalendarView() {
//        setup today
        let todayString = formatter.string(from: today)
        selectedDate = todayString
        
//        setUp calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
//        Setup label
        calendarView.visibleDates { (visibleDates) in
            self.setUpViewsOfCalendar(from: visibleDates)
        }
        
    }
    
    func fetchData() {
        fetchBodiary { (success) in
            if success {
                print("fetched bodiary data!")
            }
        }
    }
    
    func swipeUp() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animatedViewUp))
        swipe.direction = .up
        exerciseInfoView.addGestureRecognizer(swipe)
    }
    
    func swipeDown() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animatedViewDown))
        swipe.direction = .down
        exerciseInfoView.addGestureRecognizer(swipe)
    }
    
    @objc func animatedViewUp() {
        swipeUpConstraint.constant = 90
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func animatedViewDown() {
        swipeUpConstraint.constant = 90 + 250
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    func configureCell(cell: JTAppleCell, cellState: CellState) {
        guard let myCell = cell as? CalendarCell else { return }
        handleCellSelected(view: myCell, cellState: cellState)
        handleCellTextColor(view: myCell, cellState: cellState)
        handleCellVisibility(cell: myCell, cellState: cellState)
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? CalendarCell else { return }
        if cell.isSelected {
            cell.selectedView.isHidden = false
            
        } else {
            cell.selectedView.isHidden = true
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else { return }
        
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = outSideMonthColor
            }
        }
    }
    
    func handleCellVisibility(cell: CalendarCell, cellState: CellState) {
        cell.isHidden = cellState.dateBelongsTo == .thisMonth ? false : true
    }


    func setUpViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first?.date
        
        self.formatter.dateFormat = "yyyy"
        let year = self.formatter.string(from: date!)
        self.formatter.dateFormat = "MM"
        let month = self.formatter.string(from: date!)
        self.yearAndMonthLabel.text = "\(year).\(month)"
    }
    
    @IBAction func collectionVCBtnPressed(_ sender: Any) {
        guard let collectionVC = storyboard?.instantiateViewController(withIdentifier: "CollectionVC") as? CollectionVC else { return }
        present(collectionVC, animated: false, completion: nil)
    }
    
    @IBAction func goToHomeBtnPressed(_ sender: Any) {
        guard let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else { return }
        present(homeVC, animated: false, completion: nil)
    }
    
    @IBAction func goToConfigurationBtnPressed(_ sender: Any) {
        guard let configurationVC = storyboard?.instantiateViewController(withIdentifier: "ConfigurationVC") as? ConfigurationVC else { return }
        present(configurationVC, animated: false, completion: nil)
    }
    
    
    // image pick process
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        // delete 버튼 이미지 파일명이 add or delete 파라미터로 사용됨.
        
        if addBtn.currentImage != UIImage(named: "ic_delete") {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self

            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let photoAlert = UIAlertAction(title: "사진앨범에서 가져오기", style: .default, handler: { (action: UIAlertAction) in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            let cameraAlert = UIAlertAction(title: "카메라로 찍기", style: .default, handler: { (action: UIAlertAction) in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: false, completion: nil)
            })
            let cancel = UIAlertAction(title: "취소", style: .destructive)
            

            
            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popoverPresentationController = alert.popoverPresentationController {
                    popoverPresentationController.sourceView = self.view
                    popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverPresentationController.permittedArrowDirections = []
                    
                    alert.addAction(photoAlert)
                    alert.addAction(cancel)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                alert.addAction(photoAlert)
                alert.addAction(cameraAlert)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
            }
            

        } else if self.addBtn.currentImage == UIImage(named: "ic_delete") {
            let addAlert = UIAlertController(title: "삭제하시겠습니까?", message: "해당 날짜에 저장된 모든 정보가 삭제됩니다.", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { (action: UIAlertAction) in
                guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
                let index = self.eventsFromCoreData.index(of: self.selectedDate)
                print(self.selectedDate)
                managedContext.delete(self.bodiaries[index!])
                guard let calendarVC = self.storyboard?.instantiateViewController(withIdentifier: "CalendarVC") as? CalendarVC else { return }
                
                do {
                    try managedContext.save()
                    print("Successfully removed bodiary!")
                    self.present(calendarVC, animated: false, completion: nil)
                } catch {
                    debugPrint("Could not remove: \(error.localizedDescription)")
                }
            })
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            addAlert.addAction(deleteAction)
            addAlert.addAction(cancelAction)
            self.present(addAlert, animated: true, completion: nil)

        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            guard let createBodiaryVC = storyboard?.instantiateViewController(withIdentifier: "CreateBodiaryVC") as? CreateBodiaryVC else { return }
            createBodiaryVC.initData(fromImage: image, forDate: selectedDate)
            picker.dismiss(animated: true, completion: {
                self.present(createBodiaryVC, animated: false, completion: nil)
            })
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension CalendarVC: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2030 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}

extension CalendarVC: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        
        configureCell(cell: cell, cellState: cellState)
        formatter.dateFormat = "yyyy MM dd"
        if eventsFromCoreData.contains(formatter.string(from: date)) {
            cell.dumbbellImageView.isHidden = false
        } else {
            cell.dumbbellImageView.isHidden = true
        }
        return cell
    }
    
    func setUpEventArray() {
        if self.bodiaries.count > 0 {
            for i in 0 ..< self.bodiaries.count {
                self.eventsFromCoreData.append(self.bodiaries[i].date!)
            }
        }
        print(eventsFromCoreData.count)
    }
    
    func setUpCell() {
        if self.eventsFromCoreData.contains(selectedDate) {
            let index = eventsFromCoreData.index(of: selectedDate)
            let bodiary = bodiaries[index!]
            bodyImageView.image = UIImage(data: bodiary.image!)
            bodyDescTextView.text = bodiary.diary
            weightLabel.text = "\(bodiary.weight) kg"
            addBtn.setImage(UIImage(named: "ic_delete"), for: .normal)
        } else {
            bodyImageView.image = UIImage(named: "ic_account_circle_48pt_3x")
            bodyDescTextView.text = "다이어리..."
            weightLabel.text = "0 kg"
            addBtn.setImage(UIImage(named: "ic_add_circle_outline_white_36pt"), for: .normal)
        }
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let myCell = cell as? CalendarCell else { return }
        configureCell(cell: myCell, cellState: cellState)
        
        formatter.dateFormat = "yyyy"
        let yearString = formatter.string(from: cellState.date)
        formatter.dateFormat = "MM"
        let monthString = formatter.string(from: cellState.date)
        formatter.dateFormat = "dd"
        let dayString = formatter.string(from: cellState.date)
        self.selectedDate = "\(yearString) \(monthString) \(dayString)"
        
        setUpCell()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let myCell = cell as? CalendarCell else { return }
        configureCell(cell: myCell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpViewsOfCalendar(from: visibleDates)
    }
}

extension CalendarVC {
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

