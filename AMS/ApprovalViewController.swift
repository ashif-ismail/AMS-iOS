//
//  FirstViewController.swift
//  AMS
//
//  Created by DOT Developer DOT on 30/12/2019.
//  Copyright © 2019 Doodle. All rights reserved.
//

import UIKit
import JGProgressHUD
import SideMenu

class ApprovalViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ActionTakenProtocol {
    func onActionTaken() {
        //getData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return approvalRequestList.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as? RequestDetailViewController
        controller?.delegate = self
        controller?.approvalRequest = approvalRequestList[indexPath.row]
        self.present(controller!, animated: true, completion: nil)
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestItemCellTableViewCell") as? RequestItemCellTableViewCell
        cell?.profileImage.layer.cornerRadius = (cell?.profileImage.frame.size.width)! / 2
        cell?.profileImage.clipsToBounds = true
        
        cell?.txtRequestID.textColor = AppUtils.hexStringToUIColor(hex: "#90DB6D")
        cell?.headerModified.textColor = AppUtils.hexStringToUIColor(hex: "#90DB6D")
        
        cell?.submittedBy.text = approvalRequestList[indexPath.row].firstName + " " + approvalRequestList[indexPath.row].lastName
            + " " + approvalRequestList[indexPath.row].designation
        cell?.requestSubject.text = approvalRequestList[indexPath.row].subject
        cell?.txtRequestID.text = "#\(approvalRequestList[indexPath.row].id)"
        cell?.txtCreatedOn.text = approvalRequestList[indexPath.row].createdOn
        cell?.txtModifiedOn.text = approvalRequestList[indexPath.row].updatedOn
        cell?.profileImage.load(url: URL(string: approvalRequestList[indexPath.row].image)!)
        

        //cell?.txtHR.layer.borderColor = AppUtils.hexStringToUIColor(hex: "#90DB6D").cgColor
        //cell?.txtHR.layer.borderWidth = 2.0
        //cell?.txtHR.layer.cornerRadius = 6.0
        
        let data = approvalRequestList[indexPath.row]
        
        if data.hrLast == nil {
            //cell?.txtHR.isHidden = true
        } else if (data.hrLast?.elementsEqual("1"))! {
            let attachement = NSTextAttachment()
            attachement.image = UIImage(named: "tick")
            let attachmentString = NSAttributedString(attachment: attachement)
            let hrString = NSMutableAttributedString(string: "HR  ")
            hrString.append(attachmentString)
            cell?.txtHR.attributedText = hrString
            cell?.txtHR.textColor = AppUtils.hexStringToUIColor(hex: "#90DB6D")
        } else if (data.hrLast?.elementsEqual("2"))! {
            let attachement = NSTextAttachment()
            attachement.image = UIImage(named: "wrong")
            let attachmentString = NSAttributedString(attachment: attachement)
            let hrString = NSMutableAttributedString(string: "HR  ")
            hrString.append(attachmentString)
            cell?.txtHR.attributedText = hrString
            cell?.txtHR.textColor = AppUtils.hexStringToUIColor(hex: "#FC6262")
        }
        
        if data.ceoLast == nil {
            //cell?.txtCeo.isHidden = true
        } else if (data.ceoLast?.elementsEqual("1"))! {
            let attachement = NSTextAttachment()
            attachement.image = UIImage(named: "tick")
            let attachmentString = NSAttributedString(attachment: attachement)
            let hrString = NSMutableAttributedString(string: "CEO  ")
            hrString.append(attachmentString)
            cell?.txtCeo.attributedText = hrString
            cell?.txtCeo.textColor = AppUtils.hexStringToUIColor(hex: "#90DB6D")
        } else if (data.ceoLast?.elementsEqual("2"))! {
            let attachement = NSTextAttachment()
            attachement.image = UIImage(named: "wrong")
            let attachmentString = NSAttributedString(attachment: attachement)
            let hrString = NSMutableAttributedString(string: "CEO  ")
            hrString.append(attachmentString)
            cell?.txtCeo.attributedText = hrString
            cell?.txtCeo.textColor = AppUtils.hexStringToUIColor(hex: "#FC6262")
        }
        
        if data.chairmanLast == nil {
            //cell?.txtCeo.isHidden = true
        } else if (data.chairmanLast?.elementsEqual("1"))! {
            let attachement = NSTextAttachment()
            attachement.image = UIImage(named: "tick")
            let attachmentString = NSAttributedString(attachment: attachement)
            let hrString = NSMutableAttributedString(string: "CM  ")
            hrString.append(attachmentString)
            cell?.txtCM.attributedText = hrString
            cell?.txtCM.textColor = AppUtils.hexStringToUIColor(hex: "#90DB6D")
        } else if (data.chairmanLast?.elementsEqual("2"))! {
            let attachement = NSTextAttachment()
            attachement.image = UIImage(named: "wrong")
            let attachmentString = NSAttributedString(attachment: attachement)
            let hrString = NSMutableAttributedString(string: "CM  ")
            hrString.append(attachmentString)
            cell?.txtCM.attributedText = hrString
            cell?.txtCM.textColor = AppUtils.hexStringToUIColor(hex: "#FC6262")
        }
        
        return cell!
    }

    @IBOutlet weak var txtCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgBurger: UIImageView!
    @IBOutlet weak var imgSearch: UIImageView!
    var approvalRequestList: RequestListResponse!
    var hud: JGProgressHUD?
    var menu: UISideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCell()
        self.tableView.separatorColor = UIColor.clear
        
        imgBurger.isUserInteractionEnabled = true
        let burgerTap = UITapGestureRecognizer(target: self, action: #selector(self.handleBurgerTap(_:)))
        imgBurger.addGestureRecognizer(burgerTap)
        
        imgSearch.isUserInteractionEnabled = true
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSearchTap(_:)))
        imgSearch.addGestureRecognizer(searchTap)

        hud = JGProgressHUD(style: .light)
        hud!.textLabel.text = "Getting Requests waiting for approval.."
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getData()
    }
    
    func getData() {
        hud?.show(in: self.view, animated: true)
        let url = URL(string: AppUtils.AppConstants.BASE_URL.rawValue + AppUtils.resolveUserType(userType: UserDefaults.standard.getUserType()))
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(UserDefaults.standard.getAccessToken())",forHTTPHeaderField: "Authorization")
        
        let requestListTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    self.hud?.dismiss()
                    self.approvalRequestList = try decoder.decode(RequestListResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                        self.txtCount.text = "There are \(self.approvalRequestList.count) requests waiting for approval"
                    }
                    
                } catch {
                    self.hud?.dismiss()
                    print(error.localizedDescription)
                }
            }
        }
        requestListTask.resume()
    }
    
    func registerTableViewCell() {
        let requestItemCell = UINib(nibName: "RequestItemCellTableViewCell", bundle: nil)
        self.tableView.register(requestItemCell, forCellReuseIdentifier: "RequestItemCellTableViewCell")
    }
    
    
    @objc func handleBurgerTap(_ sender: UITapGestureRecognizer? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "drawerVC") as? DrawerViewController
        let menu = UISideMenuNavigationController(rootViewController: controller!)
        menu.menuWidth = UIScreen.main.bounds.width - 75
        SideMenuManager.default.menuRightNavigationController = menu
        present(menu, animated: true, completion: nil)
    }
    
    @objc func handleSearchTap(_ sender: UITapGestureRecognizer? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "searchVC") as? SearchViewController
        controller?.source = approvalRequestList
        self.present(controller!, animated: true, completion: nil)
    }
    
}

