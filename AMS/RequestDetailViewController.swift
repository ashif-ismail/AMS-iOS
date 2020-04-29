//
//  RequestDetailViewController.swift
//  AMS
//
//  Created by DOT Developer DOT on 06/01/2020.
//  Copyright © 2020 Doodle. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol ActionTakenProtocol {
    func onActionTaken()
}

class RequestDetailViewController: UIViewController,CommentProtocol {
    
    func onCommentEntered(comment: String) {
            self.comment = comment
            print(comment)
    }
    
    var approvalRequest: RequestListResponseElement!
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var txtModifiedOn: UILabel!
    @IBOutlet weak var txtCreatedOn: UILabel!
    @IBOutlet weak var txtReqID: UILabel!
    @IBOutlet weak var txtRequestDetails: UITextView!
    @IBOutlet weak var txtRequestTitle: UILabel!
    @IBOutlet weak var txtSubmittedBy: UILabel!
    @IBOutlet weak var txtModifiedOnHeader: UILabel!
    @IBOutlet weak var btnComment: UIView!
    @IBOutlet weak var btnReject: UIView!
    @IBOutlet weak var btnApprove: UIView!
    @IBOutlet weak var btnClose: UIImageView!
    
    var comment: String?
    var delegate: ActionTakenProtocol?
    var hud: JGProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtModifiedOn.text = approvalRequest.updatedOn
        txtCreatedOn.text = approvalRequest.createdOn
        txtReqID.text = "#\(approvalRequest.id)"
        txtRequestDetails.text = approvalRequest.requestListResponseDescription
        txtRequestTitle.text = approvalRequest.subject
        txtSubmittedBy.text = approvalRequest.firstName + " " + approvalRequest.lastName + " " + approvalRequest.designation
        
        profileImg.load(url: URL(string: approvalRequest!.image)!)
        txtReqID.textColor = AppUtils.hexStringToUIColor(hex: "#6DDBA6")
        txtModifiedOnHeader.textColor = AppUtils.hexStringToUIColor(hex: "#6DDBA6")
        
        txtRequestDetails.sizeToFit()
        
        btnClose.isUserInteractionEnabled = true
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseTap(_:)))
        btnClose.addGestureRecognizer(closeTap)
        
        btnApprove.isUserInteractionEnabled = true
        let approveTap = UITapGestureRecognizer(target: self, action: #selector(self.handleApproveTap(_:)))
        btnApprove.addGestureRecognizer(approveTap)
        
        btnReject.isUserInteractionEnabled = true
        let rejectTap = UITapGestureRecognizer(target: self, action: #selector(self.handleRejectTap(_:)))
        btnReject.addGestureRecognizer(rejectTap)
        
        btnComment.isUserInteractionEnabled = true
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(self.handleCommentTap(_:)))
        btnComment.addGestureRecognizer(commentTap)
        
        btnReject.layer.cornerRadius = 18
        btnApprove.layer.cornerRadius = 18
        btnComment.layer.cornerRadius = 18
        
        hud = JGProgressHUD(style: .light)
        hud!.textLabel.text = "Please wait a moment..."
    }
    
    @objc func handleCloseTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleApproveTap(_ sender: UITapGestureRecognizer? = nil) {
        
        hud?.show(in: self.view, animated: true)
        
        var urlString = AppUtils.AppConstants.BASE_URL.rawValue + AppUtils.resolveUserType(userType: UserDefaults.standard.getUserType()) + "/approval/\(approvalRequest.id)"
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: getPostBody(),options: [])
        urlRequest.setValue("Bearer \(UserDefaults.standard.getAccessToken())",forHTTPHeaderField: "Authorization")
        
        let approveTask = URLSession.shared.uploadTask(with: urlRequest, from: urlRequest.httpBody) { (data, response, error) in
            if data !=  nil {
                let status = (response as! HTTPURLResponse).statusCode
                if status == 200 {
                    self.hud?.dismiss()
                    let alert = UIAlertController(title: "AMS", message: "Request approved successfully...", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            self.dismiss(animated: true, completion: nil)
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                            
                            
                        }}))
                    self.present(alert, animated: true, completion: nil)
                    self.delegate?.onActionTaken()
                } else {
                    self.hud?.dismiss()
                    let alert = UIAlertController(title: "AMS", message: "Something went wrong,could not process the request", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            self.dismiss(animated: true, completion: nil)
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                            
                            
                        }}))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        approveTask.resume()
    }
    
    @objc func handleRejectTap(_ sender: UITapGestureRecognizer? = nil) {
        hud?.show(in: self.view, animated: true)
        var urlString = AppUtils.AppConstants.BASE_URL.rawValue + AppUtils.resolveUserType(userType: UserDefaults.standard.getUserType()) + "/reject/\(approvalRequest.id)"
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: getPostBody(),options: [])
        urlRequest.setValue("Bearer \(UserDefaults.standard.getAccessToken())",forHTTPHeaderField: "Authorization")
        
        let approveTask = URLSession.shared.uploadTask(with: urlRequest, from: urlRequest.httpBody) { (data, response, error) in
            if data !=  nil {
                let status = (response as! HTTPURLResponse).statusCode
                if status == 200 {
                    self.hud?.dismiss()
                    let alert = UIAlertController(title: "AMS", message: "Request rejected successfully...", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            self.dismiss(animated: true, completion: nil)
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                            
                            
                        }}))
                    self.present(alert, animated: true, completion: nil)
                    self.delegate?.onActionTaken()
                } else {
                    self.hud?.dismiss()
                    let alert = UIAlertController(title: "AMS", message: "Something went wrong,could not process the request", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            self.dismiss(animated: true, completion: nil)
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                            
                            
                        }}))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        approveTask.resume()
    }
    
    @objc func handleCommentTap(_ sender: UITapGestureRecognizer? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "commentVC") as? CommentViewController
        controller?.delegate = self
        self.present(controller!, animated: true, completion: nil)
    }
    
    public func getPostBody() -> [String:Any] {
        let payload: [String : Any]
        payload = ["comment": self.comment]
        return payload
    }
}
