//
//  AddViewController.swift
//  MoneyCalendar
//
//  Created by 19swu02 on 2020/07/04.
//  Copyright © 2020 19swu02. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var typeSeg: UISegmentedControl!
    @IBOutlet weak var contentTextfield: UITextField!
    @IBOutlet weak var priceTextfield: UITextField!
    @IBOutlet weak var categorySeg: UISegmentedControl!
    @IBOutlet weak var etcTextfield: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var statusText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == contentTextfield{
            textField.resignFirstResponder()
            self.priceTextfield.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext }
    
    @IBAction func CategoryChoose(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 5 {
            etcTextfield.isHidden = false
        }
        else{
            etcTextfield.isHidden = true
        }
    }
    
    @IBAction func AddButton(_ sender: UIButton) {
        if(contentTextfield.text == ""){
            statusText.text = "내용을 입력해주세요."
            return
        }
        if(priceTextfield.text == ""){
            statusText.text = "금액을 입력해주세요."
        }
        else{
            let price : String = priceTextfield.text!
            if Int(price) == nil{
                statusText.text = "금액은 숫자만 입력해주세요."
                return
            }
        }
        
        let context = self.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Moneys", in: context)
        
        let object = NSManagedObject(entity: entity!, insertInto: context) // Moneys record 생성
        let price : String = priceTextfield.text!
        let formatter: DateFormatter = DateFormatter() //날짜 저장
        formatter.dateFormat = "yyyy-MM-dd"
        let datevalue = formatter.string(from:self.datePicker.date)
        
        var isSpend : Bool
        if typeSeg.selectedSegmentIndex == 0{ //지출 선택
            isSpend = true
        }
        else{ // 수입 선택
            isSpend = false
        }
        object.setValue(isSpend, forKey: "isSpend")
        object.setValue(contentTextfield.text, forKey: "content")
        object.setValue(Int(price), forKey: "price")
        object.setValue(categorySeg.selectedSegmentIndex, forKey: "category")
        object.setValue(datevalue, forKey: "date")
        if categorySeg.selectedSegmentIndex == 5 {
            object.setValue(etcTextfield.text, forKey: "etc")
        }
        
        statusText.text = "항목이 추가되었습니다."
        contentTextfield.text = ""
        priceTextfield.text = ""
        etcTextfield.text = ""
        typeSeg.selectedSegmentIndex = 0
        categorySeg.selectedSegmentIndex = 0
        
        do {
        try context.save()
            print("saved!")
        } catch let error as NSError {
        print("Could not save \(error), \(error.userInfo)") }
    }
}
