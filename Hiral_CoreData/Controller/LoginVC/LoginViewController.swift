//
//  ViewController.swift
//  Hiral_CoreData
//
//  Created by Hiral Jahlani on 15/09/21.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPIN: UITextField!
    var users = [Users]()

    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.text = ""
        txtPIN.text = ""
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = UIColor.init(rgb: 0xFFFFFF)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        ValidationCode()
    }
    
    @IBAction func btnSignupClicked(_ sender: UIButton) {
        if let signupVC = self.storyboard?.instantiateViewController(identifier: "SignupViewController") as? SignupViewController{
            self.navigationController?.pushViewController(signupVC, animated: true)
        }
    }
}

extension LoginViewController{
    
    fileprivate func ValidationCode() {
        
        if let email = txtEmail.text, let pin = txtPIN.text {
            
            if email == "" {
                openAlert(title: "Alert", message: "Please Enter Email.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Email ID clicked!")
                }])
            }
            else if !email.validateEmailId(){
                openAlert(title: "Alert", message: "Please Enter Valid Email.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Email validation clicked!")
                }])
            }else if pin == "" {
                openAlert(title: "Alert", message: "Please Enter 4 Digits Pin", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Pin clicked!")
                }])
            }else {
                // Navigation - Home Screen
                users = DatabaseHelper.shareInstance.getUsersData()
                var userFound: Users?
                
                for user in users {
                    if user.email == txtEmail.text && user.pin == txtPIN.text {
                        userFound = user
                        break
                    }
                }
                if userFound != nil {
                    UserDefaults.standard.set(true, forKey: "flag")
                    if let dataDisplayVC = self.storyboard?.instantiateViewController(identifier: "DataDisplayViewController") as? DataDisplayViewController{
                        dataDisplayVC.user = userFound
                        self.navigationController?.pushViewController(dataDisplayVC, animated: true)
                    }
                } else {
                    openAlert(title: "Alert", message: "Please Enter Valid Email And Pin", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                        print("Okay clicked!")
                    }])
                }
            }
        }
    }
}
extension  LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // PIN
        if txtPIN == textField {
            let maxLength = 4
            let currentString: NSString = (txtPIN.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else{
            return true
        }
    }
}
