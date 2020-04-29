//
//  CommentViewController.swift
//  AMS
//
//  Created by DOT Developer DOT on 07/01/2020.
//  Copyright © 2020 Doodle. All rights reserved.
//

import UIKit

protocol CommentProtocol {
    func onCommentEntered(comment: String)
}

class CommentViewController: UIViewController {
    
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var btnDone: UIView!
    @IBOutlet weak var btnSkip: UIView!
    
    var delegate: CommentProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnDone.layer.cornerRadius = 18
        btnSkip.layer.borderColor = AppUtils.hexStringToUIColor(hex: "#54B6FD").cgColor
        btnSkip.layer.borderWidth = 2.0
        btnSkip.layer.cornerRadius = 18
        txtComment.layer.borderWidth = 2.0
        txtComment.layer.cornerRadius = 10
        txtComment.layer.borderColor = UIColor.gray.cgColor
        
        btnDone.isUserInteractionEnabled = true
        let doneTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoneTap(_:)))
        btnDone.addGestureRecognizer(doneTap)
        
        btnSkip.isUserInteractionEnabled = true
        let skipTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSkipTap(_:)))
        btnSkip.addGestureRecognizer(skipTap)
    }
    
    @objc func handleDoneTap(_ sender: UITapGestureRecognizer? = nil) {
        if txtComment.text.isEmpty {
            let negativeAlert = UIAlertController(title: "AMS", message: "Enter your comments for this request...", preferredStyle: .alert)
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
        } else {
            delegate?.onCommentEntered(comment: txtComment.text)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleSkipTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
