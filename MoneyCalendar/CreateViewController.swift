//
//  CreateViewController.swift
//  MoneyCalendar
//
//  Created by 19swu02 on 2020/07/04.
//  Copyright © 2020 19swu02. All rights reserved.
//
import UIKit

class CreateViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var SexSegment: UISegmentedControl!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    var sex : String = "female"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameTextField {
            textField.resignFirstResponder()
            self.idTextField.becomeFirstResponder()
        }
        else if textField == self.idTextField{
            textField.resignFirstResponder()
        self.passwordTextField.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func CheckBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func CreateID(_ sender: UIButton) {
        if nameTextField.text == "" {
            let alert = UIAlertController(title:"이름을 입력해주세요",message: "",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        else if idTextField.text == "" {
            let alert = UIAlertController(title:"아이디를 입력해주세요",message: "",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }

        else if passwordTextField.text == "" {
            let alert = UIAlertController(title:"비밀번호를 입력해주세요",message: "",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        else if ageTextField.text == "" {
            let alert = UIAlertController(title:"나이를 입력해주세요",message: "",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        else if Int(ageTextField.text!) == nil {
            let alert = UIAlertController(title:"나이 란에는 숫자만 입력해주세요",message: "",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        else if agreeButton.isSelected == false {
            let alert = UIAlertController(title:"정보 사용에 동의해주세요",message: "",preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        //계정 생성
        print("create Account")
        if(SexSegment.selectedSegmentIndex == 1){
            sex = "male"
        }
        print(sex)
        print(ageTextField.text!)
        let urlString: String = "http://condi.swu.ac.kr/student/M11/login/insertUser.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "id=" + idTextField.text! + "&password=" + passwordTextField.text! + "&name=" + nameTextField.text! + "&sex=" + sex + "&age=" + ageTextField.text!
        request.httpBody = restString.data(using: .utf8)
        self.executeRequest(request: request)
        
        
    }
    func executeRequest (request: URLRequest) -> Void {
        let session = URLSession.shared
        let task = session.dataTask(with: request){(responseData, response, responseError) in
            guard responseError == nil else {
                self.statusLabel.text = "Error: calling POST"
                return
            }
            guard let receiveData = responseData else{
                self.statusLabel.text = "Error: not receiving Data"
                return
            }
            if let utf8Data = String(data: receiveData, encoding: .utf8){
                DispatchQueue.main.async {
                    self.statusLabel.text = utf8Data
                    
                }
            }
        }
        task.resume()
        
    }
    @IBAction func BackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
