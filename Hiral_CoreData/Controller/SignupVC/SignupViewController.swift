//
//  SignupViewController.swift
//  Hiral_CoreData
//
//  Created by Hiral Jahlani on 15/09/21.
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtBio: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtPIN: UITextField!
    
    var isProfilePicSelected = false
    var photoName = ""
    var users = [Users]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgProfile.addGestureRecognizer(tapGesture)
        
    }
    
    @objc
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        openCamera()
    }
    
    
    @IBAction func btnSignupClicked(_ sender: UIButton) {
        var pinValid = true
        var emailValid = true
        
        users = DatabaseHelper.shareInstance.getUsersData()
        
        for user in users {
            if user.pin != txtPIN.text {
                pinValid = true
            } else {
                pinValid = false
                break
            }
        }
        for user in users {
            if user.email != txtEmail.text {
                emailValid = true
            } else {
                emailValid = false
                break
            }
        }
        let imgSystem = UIImage(systemName: "person.crop.circle.badge.plus")
        
        if imgProfile.image?.pngData() != imgSystem?.pngData(){
            // profile image selected
            if let fullname = txtFullName.text, let email = txtEmail.text, let mobile = txtMobile.text, let bio = txtBio.text, let pin = txtPIN.text{
                
                
                //FULL NAME
                if fullname == "" {
                    print("Please enter fullname")
                    openAlert(title: "Alert", message: "Please Enter Full Name.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
                }
                // EMAIL
                else if email == "" {
                    openAlert(title: "Alert", message: "Please Enter Email.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
                    print("please enter email id")
                }else if !email.validateEmailId(){
                    openAlert(title: "Alert", message: "Please Enter Valid Email.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
                    print("email is not valid")
                }else if emailValid == false {
                    openAlert(title: "Alert", message: "Email Address is Already Registered", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
                    print("Email Address is Already Registered")
                }
                
                //MOBILE NO
                else if mobile == "" {
                    openAlert(title: "Alert", message: "Please Enter Mobile Number", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
                    print("please enter mobile number")
                } else if mobile.count <= 9 {
                    openAlert(title: "Alert", message: "Please Enter Valid Mobile Number of 10 Digits", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
                    print("Please enter valid mobile number of 10 digits")
                    
                //BIO
                } else if bio == "" {
                    openAlert(title: "Alert", message: "Please Enter Bio ", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
                    print("please enter bio")
                    
                //PROFILE PIC
                } else if isProfilePicSelected == false {
                    openAlert(title: "Alert", message: "Please Select Profile Pic ", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
                    print("please select profile pic")
                    
                //PIN
                } else if pin == "" {
                    openAlert(title: "Alert", message: "Please Enter Pin.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
                    print("please enter pin")
                    
                //PIN
                } else if pinValid == false {
                    openAlert(title: "Alert", message: "Please Enter Unique Pin ", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
                    print("please enter unique pin")
                    
                }
                else{
                    print("Please check your details")
                    
                    let dict = ["fullname":txtFullName.text, "email":txtEmail.text, "mobile":txtMobile.text, "bio":txtBio.text, "profilepic": photoName + ".jpg", "pin":txtPIN.text] as [String : Any]
                    
                    let user = DatabaseHelper.shareInstance.save(object: dict as! [String : String])
                    UserDefaults.standard.set(true, forKey: "flag")
                    
                    if let dataDisplayVC = self.storyboard?.instantiateViewController(identifier: "DataDisplayViewController") as? DataDisplayViewController{
                        dataDisplayVC.user = user
                        self.navigationController?.pushViewController(dataDisplayVC, animated: true)
                    }
                }
            }
        }
    }
    
    //SavePhotoToDocumentDirectory
    func savePhotoToDocumentDirectory(imageProfile:UIImage, fileName:String) {
        
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        let fileName = "\(fileName).jpg"
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let data = imageProfile.jpegData(compressionQuality:  1.0),
          !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // writes the image data to disk
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    //COREDATA:- SAVE
    func saveCoreData() {
        let dict = ["fullname":txtFullName.text, "email":txtEmail.text, "mobile":txtMobile.text, "bio":txtBio.text, "profilepic": photoName + ".jpg", "pin":txtPIN.text] as [String : Any]
        
        DatabaseHelper.shareInstance.save(object: dict as! [String : String])
    }
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension  SignupViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if newString.hasPrefix(" "){
            textField.text = ""
            return false
        //FULLNAME
        }else if txtFullName == textField {
            let maxLength = 15
            let currentString: NSString = (txtFullName.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
//      }
        // MOBILE
//        else if txtMobile == textField {
//            let maxLength = 10
//            let currentString: NSString = (txtMobile.text ?? "") as NSString
//            let newString: NSString =
//                currentString.replacingCharacters(in: range, with: string) as NSString
//            return newString.length <= maxLength
            
        }else if txtMobile == textField {
                textField.text = formattedNumber(number: newString, mask: "(XX) XXXX-XXXX")
                return false
        }
            
        // BIO
        else if txtBio == textField {
            
            let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890-.,"
            //.@#$%^&!()}{|\":;?><~+_][/*-
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            
            let maxLength = 30
            let currentString: NSString = (txtBio.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength && alphabet
        }
        
        // PIN
        else if txtPIN == textField {
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

extension SignupViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
        
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        photoName = self.randomString(length: 5)
        if let img = info[.originalImage] as? UIImage{
            imgProfile.image = img
            self.savePhotoToDocumentDirectory(imageProfile: img, fileName: photoName)
            isProfilePicSelected = true
        }
        dismiss(animated: true)
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
