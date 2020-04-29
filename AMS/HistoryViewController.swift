//
//  HistoryViewController.swift
//  AMS
//
//  Created by DOT Developer DOT on 30/12/2019.
//  Copyright © 2019 Doodle. All rights reserved.
//

import UIKit
import JGProgressHUD
import SideMenu

class HistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (completedList?.data.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestItemCellTableViewCell") as? RequestItemCellTableViewCell
        cell?.profileImage.layer.cornerRadius = (cell?.profileImage.frame.size.width)! / 2
        cell?.profileImage.clipsToBounds = true
        
        cell?.txtRequestID.textColor = AppUtils.hexStringToUIColor(hex: "#90DB6D")
        cell?.headerModified.textColor = AppUtils.hexStringToUIColor(hex: "#90DB6D")
        
        cell?.submittedBy.text = (completedList?.data[indexPath.row].firstName)! + " " + (completedList?.data[indexPath.row].lastName)!
            + " " + (completedList?.data[indexPath.row].designation)!
        cell?.requestSubject.text = completedList?.data[indexPath.row].subject
        cell?.txtRequestID.text = "#\(completedList!.data[indexPath.row].id)"
        cell?.txtCreatedOn.text = completedList?.data[indexPath.row].createdOn
        cell?.txtModifiedOn.text = completedList?.data[indexPath.row].updatedOn
        cell?.profileImage.load(url: URL(string: (completedList?.data[indexPath.row].image)!)!)
        
        
        //cell?.txtHR.layer.borderColor = AppUtils.hexStringToUIColor(hex: "#90DB6D").cgColor
        //cell?.txtHR.layer.borderWidth = 2.0
        //cell?.txtHR.layer.cornerRadius = 6.0
        
        let data = completedList?.data[indexPath.row]
        
        if data!.hrLast == nil {
            //cell?.txtHR.isHidden = true
        } else if (data!.hrLast?.elementsEqual("1"))! {
            let attachement = NSTextAttachment()
            attachement.image = UIImage(named: "tick")
            let attachmentString = NSAttributedString(attachment: attachement)
            let hrString = NSMutableAttributedString(string: "HR  ")
            hrString.append(attachmentString)
            cell?.txtHR.attributedText = hrString
            cell?.txtHR.textColor = AppUtils.hexStringToUIColor(hex: "#90DB6D")
        } else if (data!.hrLast?.elementsEqual("2"))! {
            let attachement = NSTextAttachment()
            attachement.image = UIImage(named: "wrong")
            let attachmentString = NSAttributedString(attachment: attachement)
            let hrString = NSMutableAttributedString(string: "HR  ")
            hrString.append(attachmentString)
            cell?.txtHR.attributedText = hrString
            cell?.txtHR.textColor = AppUtils.hexStringToUIColor(hex: "#FC6262")
        }
        
        if data!.ceoLast == nil {
            //cell?.txtCeo.isHidden = true
        } else if (data!.ceoLast?.elementsEqual("1"))! {
            let attachement = NSTextAttachment()
            attachement.image = UIImage(named: "tick")
            let attachmentString = NSAttributedString(attachment: attachement)
            let hrString = NSMutableAttributedString(string: "CEO  ")
            hrString.append(attachmentString)
            cell?.txtCeo.attributedText = hrString
            cell?.txtCeo.textColor = AppUtils.hexStringToUIColor(hex: "#90DB6D")
        } else if (data!.ceoLast?.elementsEqual("2"))! {
            let attachement = NSTextAttachment()
            attachement.image = UIImage(named: "wrong")
            let attachmentString = NSAttributedString(attachment: attachement)
            let hrString = NSMutableAttributedString(string: "CEO  ")
            hrString.append(attachmentString)
            cell?.txtCeo.attributedText = hrString
            cell?.txtCeo.textColor = AppUtils.hexStringToUIColor(hex: "#FC6262")
        }
        
        if data!.chairmanLast == nil {
            //cell?.txtCeo.isHidden = true
        } else if (data!.chairmanLast?.elementsEqual("1"))! {
            let attachement = NSTextAttachment()
            attachement.image = UIImage(named: "tick")
            let attachmentString = NSAttributedString(attachment: attachement)
            let hrString = NSMutableAttributedString(string: "CM  ")
            hrString.append(attachmentString)
            cell?.txtCM.attributedText = hrString
            cell?.txtCM.textColor = AppUtils.hexStringToUIColor(hex: "#90DB6D")
        } else if (data!.chairmanLast?.elementsEqual("2"))! {
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
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var search: UIImageView!
    @IBOutlet weak var burger: UIImageView!
    
    var hud: JGProgressHUD?
    var completedList: HistoryListResponse?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCell()
        
        self.tableView.separatorColor = UIColor.clear
        
        burger.isUserInteractionEnabled = true
        let burgerTap = UITapGestureRecognizer(target: self, action: #selector(self.handleBurgerTap(_:)))
        burger.addGestureRecognizer(burgerTap)
        
        search.isUserInteractionEnabled = true
        let searchTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSearchTap(_:)))
        search.addGestureRecognizer(searchTap)
        
        hud = JGProgressHUD(style: .light)
        hud!.textLabel.text = "Getting history data..."
        
        getData()
    }
    
    func getData() {
        hud?.show(in: self.view, animated: true)
        let url = URL(string: AppUtils.AppConstants.BASE_URL.rawValue + AppUtils.resolveUserType(userType: UserDefaults.standard.getUserType()) + "/history")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(UserDefaults.standard.getAccessToken())",forHTTPHeaderField: "Authorization")
        
        let requestListTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    self.hud?.dismiss()
                    self.completedList = try decoder.decode(HistoryListResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
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
        controller?.source = completedList?.data
        self.present(controller!, animated: true, completion: nil)
    }

}
