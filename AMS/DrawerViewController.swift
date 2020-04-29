//
//  DrawerViewController.swift
//  AMS
//
//  Created by DOT Developer DOT on 09/01/2020.
//  Copyright © 2020 Doodle. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImg.contentMode = .scaleAspectFit
            profileImg.image = pickedImage
        }
        //dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var headerBg: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var deisgnation: UILabel!
    @IBOutlet weak var signOut: UILabel!
    @IBOutlet weak var imgClose: UIImageView!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btnUpdate: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = AppUtils.hexStringToUIColor(hex: "#E99A36")
        self.headerBg.backgroundColor = AppUtils.hexStringToUIColor(hex: "#E98136")
        
        imgClose.isUserInteractionEnabled = true
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseTap(_:)))
        imgClose.addGestureRecognizer(closeTap)
        
        profileImg.isUserInteractionEnabled = true
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(self.handleImgTap(_:)))
        profileImg.addGestureRecognizer(imgTap)
        
        signOut.isUserInteractionEnabled = true
        let signOutTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSignOutTap(_:)))
        signOut.addGestureRecognizer(signOutTap)
        
        profileImg.layer.cornerRadius = (profileImg.frame.size.width) / 2
        profileImg.clipsToBounds = true
        
        imagePicker.delegate = self
        
        getData()
    }
    
    func getData() {
        let url = URL(string: AppUtils.AppConstants.BASE_URL.rawValue + "profile")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(UserDefaults.standard.getAccessToken())",forHTTPHeaderField: "Authorization")
        
        let profileTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let profileResponse = try decoder.decode(ProfileResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.profileImg.load(url: URL(string: profileResponse.image)!)
                        self.name.text = "\(profileResponse.firstName! )  \(profileResponse.lastName!)"
                        self.deisgnation.text = profileResponse.designation
                        
                        self.tfFirstName.text = profileResponse.firstName
                        self.tfLastName.text = profileResponse.lastName
                        self.tfEmail.text = profileResponse.email
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
        profileTask.resume()
    }
    
    @IBAction func updatePressed(_ sender: Any) {
        
    }
    
    @objc func handleCloseTap(_ sender: UITapGestureRecognizer? = nil) {
        dismiss(animated: true, completion: nil)
    }
    @objc func handleImgTap(_ sender: UITapGestureRecognizer? = nil) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleSignOutTap(_ sender: UITapGestureRecognizer? = nil) {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "loginVC") as? LoginViewController
        //self.present(controller!, animated: true, completion: nil)
        let navigationController = UINavigationController(rootViewController: controller!)
        
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
