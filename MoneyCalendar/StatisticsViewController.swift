//
//  StatisticsViewController.swift
//  MoneyCalendar
//
//  Created by 19swu02 on 2020/07/04.
//  Copyright © 2020 19swu02. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    @IBOutlet weak var sexAgeSeg: UISegmentedControl!
    @IBOutlet weak var allAvgLabel: UILabel!
    @IBOutlet weak var allAvg: UILabel!
    @IBOutlet weak var myAvg: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    var sex : String = ""
    var fetchedArray : [MoneyData] = Array()
    var seg1Array : [MoneyData] = Array()
    var seg2Array : [MoneyData] = Array()
    var price1 : Int = 0
    var price2 : Int = 0
    var price3 : Int = 0
    var userCount : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchedArray = []
        seg1Array = []
        seg2Array = []
        let urlString: String = "http://condi.swu.ac.kr/student/M11/login/pickItem.php"
        guard let requestURL = URL(string: urlString) else { return }
        let request = URLRequest(url: requestURL)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) {
            (responseData, response, responseError) in guard responseError == nil else { print("Error: calling POST"); return; }
        guard let receivedData = responseData else {
        print("Error: not receiving Data"); return; }
        let response = response as! HTTPURLResponse
            if !(200...299 ~= response.statusCode) { print("HTTP response Error!"); return }
            do {
                if let jsonData = try JSONSerialization.jsonObject (with: receivedData, options:.allowFragments) as? [[String: Any]] {
                    for i in 0...jsonData.count-1 {
                        print(i)
                            var newData: MoneyData = MoneyData()
                            var jsonElement = jsonData[i]
                            newData.sex = jsonElement["sex"] as! String
                            newData.age = jsonElement["age"] as! String
                            newData.price = jsonElement["price"] as! String
                            newData.itemnum = jsonElement["itemnum"] as! String
                            self.fetchedArray.append(newData)
            }
            DispatchQueue.main.async { print("Success") }
            }
            }catch { print("Error: Catch") } }
            task.resume()
        //Statistics(sexageindex: sexAgeSeg.selectedSegmentIndex)
    }
    @IBAction func Segment(_ sender: UISegmentedControl) {
        Statistics(sexageindex: sexAgeSeg.selectedSegmentIndex)
    }
    @IBAction func BackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func Statistics(sexageindex : Int) -> Void{
        let urlString: String = "http://condi.swu.ac.kr/student/M11/login/pickItem.php"
        guard let requestURL = URL(string: urlString) else { return }
        let request = URLRequest(url: requestURL)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) {
            (responseData, response, responseError) in guard responseError == nil else { print("Error: calling POST"); return; }
        guard let receivedData = responseData else {
        print("Error: not receiving Data"); return; }
        let response = response as! HTTPURLResponse
            if !(200...299 ~= response.statusCode) { print("HTTP response Error!"); return }
            do {
                if let jsonData = try JSONSerialization.jsonObject (with: receivedData, options:.allowFragments) as? [[String: Any]] {
                    for i in 0...jsonData.count-1 {
                            var newData: MoneyData = MoneyData()
                            var jsonElement = jsonData[i]
                            newData.sex = jsonElement["sex"] as! String
                            newData.age = jsonElement["age"] as! String
                            newData.price = jsonElement["price"] as! String
                            newData.itemnum = jsonElement["itemnum"] as! String
                            self.fetchedArray.append(newData)
            }
            DispatchQueue.main.async { print("Success") }
            }
            }catch { print("Error: Catch") } }
            task.resume()
        var isFind = true
            
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if(appDelegate.sex == "female"){
            self.sex = "여성"
        }
        else{
            self.sex = "남성"
        }
        switch sexageindex {
        case 0:
            self.allAvgLabel.text = self.sex + "의 평균"

            for i in 0...fetchedArray.count-1 {
                if appDelegate.sex == fetchedArray[i].sex {
                    price1 += Int(fetchedArray[i].price)!
                    userCount += 1
                }
            }
            allAvg.text = String(price1 / userCount)
            myAvg.text = String(appDelegate.myAvg)
            
            resultLabel.text = "나의 평균은 전체 평균보다 " + String(appDelegate.myAvg-price1/userCount) + "많아요"
            userCount = 0
            price1 = 0
            
        case 1:
            self.allAvgLabel.text = String((Int(appDelegate.age!) ?? 0) / 10 * 10) + "대의 평균"
            for i in 0...fetchedArray.count-1 {
                if appDelegate.age?.startIndex == fetchedArray[i].age.startIndex{
                    price2 += Int(fetchedArray[i].price)!
                    userCount += 1
                }
                
            }
            allAvg.text = String(price2 / userCount)
            myAvg.text = String(appDelegate.myAvg)
            resultLabel.text = "나의 평균은 전체 평균보다 " + String(appDelegate.myAvg-price2/userCount) + "많아요"
            userCount = 0
            price2 = 0
        case 2:
            self.allAvgLabel.text = String((Int(appDelegate.age!) ?? 0) / 10 * 10) + "대 " + self.sex + "의 평균"
            for i in 0...fetchedArray.count-1 {
            if appDelegate.age?.startIndex == fetchedArray[i].age.startIndex && appDelegate.sex == fetchedArray[i].sex{
                price3 += Int(fetchedArray[i].price)!
                userCount += 1
            }
            }
            allAvg.text = String(price3 / userCount)
            myAvg.text = String(appDelegate.myAvg)
            resultLabel.text = "나의 평균은 전체 평균보다 " + String(appDelegate.myAvg-price3/userCount) + "많아요"
            userCount = 0
            price3 = 0
        default:
            self.allAvgLabel.text = "error"
            }
        
        
    }

}

