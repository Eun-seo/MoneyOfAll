//
//  StartViewController.swift
//  MoneyCalendar
//
//  Created by 19swu02 on 2020/07/04.
//  Copyright © 2020 19swu02. All rights reserved.
//

import UIKit
import CoreData

class StartViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var balanceValue: UITextField!
    @IBOutlet weak var statusText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext }
    @IBAction func StartButton() {
        
        let balance : String = balanceValue.text!
        if(balance == ""){
            statusText.text = "잔액을 입력해주세요."
            return
        }
        else if Int(balance) != nil{ //balance 값이 Int형식으로 변환이 가능한가?
            
            let context = self.getContext()
            let entity = NSEntityDescription.entity(forEntityName: "Moneys", in: context)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.isFirst = false
            let object = NSManagedObject(entity: entity!, insertInto: context)
            object.setValue("처음 통장 금액", forKey: "content")
            object.setValue(Int(balance), forKey: "price")
            object.setValue(false, forKey: "isSpend")
            object.setValue(5, forKey: "category")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabView = storyboard.instantiateViewController(withIdentifier: "tabView")
            tabView.modalPresentationStyle = .fullScreen
            self.present(tabView, animated: true, completion: nil)
        }
        else
        {
            statusText.text = "숫자만 입력해주세요."
            return
        }
        
    }
}
