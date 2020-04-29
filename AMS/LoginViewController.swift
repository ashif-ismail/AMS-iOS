//
//  LoginViewController.swift
//  AMS
//
//  Created by DOT Developer DOT on 31/12/2019.
//  Copyright © 2019 Doodle. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    let BASE_URL = "https://demo2.wowdle.com/alotaiba/api/v1"
    let LOGIN_URL = "/login"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.btnLogin.backgroundColor = AppUtils.hexStringToUIColor(hex: "#1D689F")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.isLoggedIn() {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    
    @IBAction func btnLoginTapped(_ sender: Any) {
        print("login tapped")
        if !(textEmail.text!.isEmpty || txtPassword.text!.isEmpty) {
            // Attempt Login API
            var alert = showLoading()
            
            let requestBody = try? JSONSerialization.data(withJSONObject: getLoginRequest(),options: [])
            let url = URL(string: BASE_URL + LOGIN_URL)!
            var loginRequest = URLRequest(url: url)
            loginRequest.httpMethod = "POST"
            loginRequest.httpBody = requestBody
            loginRequest.addValue("application/json",forHTTPHeaderField: "Content-Type")
            loginRequest.addValue("application/json",forHTTPHeaderField: "Accept")
            
            let loginTask = URLSession.shared.uploadTask(with: loginRequest, from: requestBody) { (jsonData,response,error) in
                if jsonData != nil {
                    let status = (response as! HTTPURLResponse).statusCode
                    if status == 200 {
                        let responseJSON = try? JSONSerialization.jsonObject(with: jsonData!, options: [])
                        if let responseJSON = responseJSON as? [String: Any] {
                            DispatchQueue.main.async {
                                // Save AUTH_TOKEN and USER_TYPE
                                UserDefaults.standard.setAccessToken(accessToken: responseJSON["access_token"] as! String)
                                UserDefaults.standard.setUserType(userType: Int((responseJSON["user_type"] as! NSString).intValue))
                                UserDefaults.standard.setLoggedIn(value: true)
                                alert.dismiss(animated: true, completion: {
                                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                                })
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            alert.dismiss(animated: true, completion: nil)
                            let negativeAlert = UIAlertController(title: "AMS", message: "Invalid Credentials", preferredStyle: .alert)
                            negativeAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    print("default")
                                    
                                case .cancel:
                                    print("cancel")
                                    
                                case .destructive:
                                    print("destructive")
                                    
                                    
                                }}))
                            self.present(negativeAlert, animated: true, completion: nil)
                        }
                    }
                    
                }
            }
            loginTask.resume()
        } else {
            let alert = UIAlertController(title: "AMS", message: "Username and password cannot be empty", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    

    func showLoading() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "      Please wait a moment...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        return alert
    }
    
    func getLoginRequest() -> [String: Any] {
        let payload: [String : Any]
        payload = ["email": textEmail.text!,"password":txtPassword.text!,"remember_me":true]
        return payload
    }
}
