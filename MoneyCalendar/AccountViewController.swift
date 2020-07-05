//
//  AccountViewController.swift
//  MoneyCalendar
//
//  Created by 19swu02 on 2020/07/04.
//  Copyright © 2020 19swu02. All rights reserved.
//

import UIKit
import CoreData

class AccountViewController: UIViewController {
    
    var moneys: [NSManagedObject] = []
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBOutlet weak var ageTextfield: UITextField!
    @IBOutlet weak var sexSegment: UISegmentedControl!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var notionLabel: UILabel!
    @IBOutlet weak var toLoginButton: UIButton!
    @IBOutlet weak var smallLabel: UILabel!
    @IBOutlet weak var ToSeeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.isLogin == true {
            nameLabel.isHidden = false
            ageLabel.isHidden = false
            nameTextfield.isHidden = false
            ageTextfield.isHidden = false
            logoutButton.isHidden = false
            sexSegment.isHidden = false
            notionLabel.isHidden = true
            toLoginButton.isHidden = true
            smallLabel.isHidden = false
            ToSeeButton.isHidden = false
            nameTextfield.text = appDelegate.userName
            ageTextfield.text = appDelegate.age
            if(appDelegate.sex == "female"){
                sexSegment.selectedSegmentIndex = 0
            }
            else if appDelegate.sex == "male"{
                sexSegment.selectedSegmentIndex = 1
            }
            let context = self.getContext()
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Moneys")
            do {
                moneys = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        else{
            nameLabel.isHidden = true
            ageLabel.isHidden = true
            nameTextfield.isHidden = true
            ageTextfield.isHidden = true
            logoutButton.isHidden = true
            sexSegment.isHidden = true
            notionLabel.isHidden = false
            toLoginButton.isHidden = false
            smallLabel.isHidden = true
            ToSeeButton.isHidden = true
        }
    }
    
    @IBAction func LogoutButton(_ sender: UIButton) {
        let urlString: String = "http://condi.swu.ac.kr/student/M11/login/logout.php"
        guard let requestURL = URL(string: urlString) else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
        guard responseError == nil else { return } }
        task.resume()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginView = storyboard.instantiateViewController(withIdentifier: "loginView")
        loginView.modalPresentationStyle = .fullScreen
        self.present(loginView, animated: true, completion: nil)
    }
    
    
    @IBAction func GotoLogin(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabView = storyboard.instantiateViewController(withIdentifier: "loginView")
        tabView.modalPresentationStyle = .fullScreen
        self.present(tabView, animated: true, completion: nil)
    }
    @IBAction func statisticsButton(_ sender: UIButton) {
        let urlString: String = "http://condi.swu.ac.kr/student/M11/login/insertItem.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        for i in 0...moneys.count-1 {
            let price = String((moneys[i].value(forKey: "price")as? Int)!)
            let category = String((moneys[i].value(forKey: "category")as? Int)!)
            let restString: String = "age=" + appDelegate.age! + "&sex=" + appDelegate.sex! + "&price=" + price + "&category=" + category + "&itemnum=" + appDelegate.ID! + "-" + String(i)
            request.httpBody = restString.data(using: .utf8)
            self.executeRequest(request: request)
        }
        appDelegate.myAvg /= moneys.count
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabView = storyboard.instantiateViewController(withIdentifier: "statisticsView")
        tabView.modalPresentationStyle = .fullScreen
        self.present(tabView, animated: true, completion: nil)
        
    }
    func executeRequest (request: URLRequest) -> Void {
        let session = URLSession.shared
        let task = session.dataTask(with: request){(responseData, response, responseError) in
            guard responseError == nil else {
                print("Error: calling POST")
                return
            }
            guard let receiveData = responseData else{
                print("Error: not receiving Data")
                return
            }
            if let utf8Data = String(data: receiveData, encoding: .utf8){
                DispatchQueue.main.async {
                    print(utf8Data)
                    
                }
            }
        }
        task.resume()
        
    }
  
    
}
