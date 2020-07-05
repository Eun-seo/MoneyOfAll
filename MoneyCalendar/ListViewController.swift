//
//  ListViewController.swift
//  MoneyCalendar
//
//  Created by 19swu02 on 2020/07/04.
//  Copyright © 2020 19swu02. All rights reserved.
//

import UIKit
import CoreData

class SpendCell: UITableViewCell {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var balaceValue: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var moneys: [NSManagedObject] = []
    var balance : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Moneys")
        do {
            moneys = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        
        }
        tableView.reloadData()
    }
    
    func numberOfSections (in tableView: UITableView) -> Int {
    return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moneys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpendCell", for: indexPath) as! SpendCell
        let money = moneys[indexPath.row]
        
        cell.contentLabel.text = money.value(forKey: "content")as? String
        let priceInt = money.value(forKey: "price")as? Int
        if(moneys[indexPath.row].value(forKey: "isSpend")as? Bool == false){
            cell.priceLabel.text = String(priceInt!) + "원"
        }
        else{
            cell.priceLabel.text = "-" + String(priceInt!) + "원"
        }
        
        cell.dateLabel.text = money.value(forKey: "date")as? String
        switch(money.value(forKey: "category")as? Int){
        case 0 :
            cell.categoryLabel.text = "교통비"
        case 1 :
            cell.categoryLabel.text = "식비"
        case 2 :
            cell.categoryLabel.text = "관리비"
        case 3 :
            cell.categoryLabel.text = "월급"
        case 4 :
            cell.categoryLabel.text = "여가비"
        case 5 :
            let etc = money.value(forKey: "etc")as? String
            if etc == nil {
                 cell.categoryLabel.text = ""
            }
            else{
                cell.categoryLabel.text = "기타(" + etc! + ")"}
        default :
            cell.categoryLabel.text = ""
        }
        CalculateBalance(indexPath: indexPath, isDeleted: false)
        balaceValue.text = String(balance)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myAvg = balance
        cell.balanceLabel.text = String(balance) + " 원"
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
    // Core Data 내의 해당 자료 삭제
            let context = getContext()
            context.delete(moneys[indexPath.row])
            do {
                try context.save()
                print("deleted!")
            } catch let error as NSError {
                print("Could not delete \(error), \(error.userInfo)") }
    // 배열에서 해당 자료 삭제
            moneys.remove(at: indexPath.row)
    // 테이블뷰 Cell 삭제
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        CalculateBalance(indexPath: indexPath, isDeleted: true)
        tableView.reloadData()
    }
    func CalculateBalance(indexPath: IndexPath, isDeleted : Bool){
         balance = 0
        if(indexPath.row != 0){
            if(isDeleted){
                for i in 0...indexPath.row-1 {
                    if(moneys[i].value(forKey: "isSpend")as? Bool == true){
                        balance -= (moneys[i].value(forKey: "price")as? Int)!
                    }
                    else{
                        balance += (moneys[i].value(forKey: "price")as? Int)!
                    }
                }
                if(indexPath.row == 1){
                    balance = 0
                }
            }
            else{
                for i in 0...indexPath.row {
                    if(moneys[i].value(forKey: "isSpend")as? Bool == true){
                        balance -= (moneys[i].value(forKey: "price")as? Int)!
                    }
                    else{
                        balance += (moneys[i].value(forKey: "price")as? Int)!
                    }
                }
            }
        }
        else if(isDeleted == false){
            if(moneys[0].value(forKey: "isSpend")as? Bool == true){
                balance = -(moneys[0].value(forKey: "price")as? Int)!
            }
            else{
                balance = (moneys[0].value(forKey: "price")as? Int)!
            }
        }
    }
    
}
