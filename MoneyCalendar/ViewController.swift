//
//  ViewController.swift
//  MoneyCalendar
//
//  Created by 19swu02 on 2020/07/03.
//  Copyright © 2020 19swu02. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.removeObject(forKey: "isFirst")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.idTextField{
            textField.resignFirstResponder()
            self.pwdTextField.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    @IBAction func StartWithoutLogin(_ sender: UIButton) {
        let alert = UIAlertController(title:"로그인하지 않으면 온라인 서비스를 이용할 수 없어요!",message: "",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "로그인할래요", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "괜찮아요", style: .default, handler: {action in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if(appDelegate.isFirst){
                UserDefaults.standard.set("false", forKey: "isFirst")
                let tabView = storyboard.instantiateViewController(withIdentifier: "startView")
                tabView.modalPresentationStyle = .formSheet
                self.present(tabView, animated: true, completion: nil)
                
            }
            else if (!appDelegate.isFirst){
                let tabView = storyboard.instantiateViewController(withIdentifier: "tabView")
                tabView.modalPresentationStyle = .fullScreen
                self.present(tabView, animated: true, completion: nil)
            }
             
            appDelegate.isLogin = false
            }))
        self.present(alert, animated: true)
    }
    
    @IBAction func LoginButton(_ sender: UIButton) {
        if idTextField.text == "" {
           let alert = UIAlertController(title:"아이디를 입력해주세요",message: "",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        else if pwdTextField.text == "" {
            let alert = UIAlertController(title:"비밀번호를 입력해주세요",message: "",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        let urlString : String = "http://condi.swu.ac.kr/student/M11/login/loginUser.php"
        guard let requestURL = URL(string: urlString)else {
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "id=" + idTextField.text! + "&password=" + pwdTextField.text!
        
        request.httpBody = restString.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request){(responseData, response, responseError) in
            guard responseError == nil else {
                self.statusLabel.text = "Error: calling POST"
                return
            }
            guard let receivedData = responseData else{
                self.statusLabel.text = "Error: not receiving Data"
                return
            }
            
            do{
                let response = response as! HTTPURLResponse
                if !(200...299 ~= response.statusCode) {
                    self.statusLabel.text = "HTTP Error!"
                    return
                }
                guard let jsonData = try JSONSerialization.jsonObject(with: receivedData, options: .allowFragments) as? [String: Any] else {
                    self.statusLabel.text = "JSON Serialization Error!"
                    return
                }
                guard let success = jsonData["success"]as? String else{
                    self.statusLabel.text = "Error: PHP failure(success)"
                    return
                }
                if success == "YES" {
                    if let name = jsonData["name"]as? String{
                        DispatchQueue.main.async{
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.ID = self.idTextField.text
                            appDelegate.userName = name
                            appDelegate.sex = jsonData["sex"]as? String
                            appDelegate.age = jsonData["age"]as? String

                            appDelegate.isLogin = true
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if(appDelegate.isFirst){
                                UserDefaults.standard.set("false", forKey: "isFirst")
                                let tabView = storyboard.instantiateViewController(withIdentifier: "startView")
                                tabView.modalPresentationStyle = .formSheet
                                self.present(tabView, animated: true, completion: nil)
                                
                            }
                            else{
                                let tabView = storyboard.instantiateViewController(withIdentifier: "tabView")
                                tabView.modalPresentationStyle = .fullScreen
                                self.present(tabView, animated: true, completion: nil)
                            }
                            
                            
                        }
                    }
                } else {
                        if let errMessage = jsonData["error"]as? String {
                            DispatchQueue.main.async{
                                self.statusLabel.text = errMessage
                            }
                        }
                    }
                }catch {
                    self.statusLabel.text = "Error: \(error)"
                }
            }
            task.resume()
        }


}

