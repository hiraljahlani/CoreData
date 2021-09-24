//
//  DataDisplayViewController.swift
//  Hiral_CoreData
//
//  Created by Hiral Jahlani on 15/09/21.
//

import UIKit

class DataDisplayViewController: UIViewController {

    var user:Users?
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblFullname: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblBio: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        imgProfile.makeRounded()
      
        imgProfile.image = self.loadImageFromDocumentDirectory(nameOfImage: user?.profilepic ?? "") 
        lblFullname.text = user?.fullname
        lblMobile.text = user?.mobile
        lblBio.text = user?.bio
    }
    
    @IBAction func btnLogoutClicked(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func loadImageFromDocumentDirectory(nameOfImage : String) -> UIImage {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first{
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
            let image    = UIImage(contentsOfFile: imageURL.path)
            return image ?? UIImage()
        }
        return UIImage.init(named: "default.png")!
    }
}


