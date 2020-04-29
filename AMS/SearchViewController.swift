//
//  SearchViewController.swift
//  AMS
//
//  Created by DOT Developer DOT on 08/01/2020.
//  Copyright © 2020 Doodle. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filter!.count
        }
        
        return source!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestItemCellTableViewCell") as? RequestItemCellTableViewCell
        cell?.profileImage.layer.cornerRadius = (cell?.profileImage.frame.size.width)! / 2
        cell?.profileImage.clipsToBounds = true
        
        var data :RequestListResponseElement
        
        if isFiltering {
            data = self.filter![indexPath.row]
        } else {
            data = self.source![indexPath.row]
        }
    
    
        
        cell?.txtRequestID.textColor = AppUtils.hexStringToUIColor(hex: "#90DB6D")
        cell?.headerModified.textColor = AppUtils.hexStringToUIColor(hex: "#90DB6D")
        
        cell?.submittedBy.text = data.firstName + " " + data.lastName
            + " " + data.designation
        cell?.requestSubject.text = data.subject
        cell?.txtRequestID.text = "#\(data.id)"
        cell?.txtCreatedOn.text = data.createdOn
        cell?.txtModifiedOn.text = data.updatedOn
        cell?.profileImage.load(url: URL(string: data.image)!)
        
        
        //cell?.txtHR.layer.borderColor = AppUtils.hexStringToUIColor(hex: "#90DB6D").cgColor
        //cell?.txtHR.layer.borderWidth = 2.0
        //cell?.txtHR.layer.cornerRadius = 6.0
        
    
        
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
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var source: RequestListResponse?
    var filter: RequestListResponse?
    private var filtered: RequestListResponse?
    
    private var searchText = String()
    
    func filterContentForSearchText(_ searchText: String,
                                    category: RequestListResponse) {
        filter = source!.filter { (item: RequestListResponseElement) -> Bool in
            return String(item.id).contains(searchText.lowercased())
        }
        
        tableview.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCell()
        self.tableview.separatorColor = UIColor.clear
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        
        imgSearch.isUserInteractionEnabled = true
        let searchtap = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseTap(_:)))
        imgSearch.addGestureRecognizer(searchtap)
        
        self.tableview.tableHeaderView = searchController.searchBar
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
            navigationItem.titleView = searchController.searchBar
            navigationItem.titleView?.layoutSubviews()
        }
        navigationItem.hidesSearchBarWhenScrolling = false
        
        tableview.dataSource = self
        tableview.delegate = self
        
        source = source!.sorted(by: { $0.id < $1.id })
        filtered = source
    }
    
    func registerTableViewCell() {
        let requestItemCell = UINib(nibName: "RequestItemCellTableViewCell", bundle: nil)
        self.tableview.register(requestItemCell, forCellReuseIdentifier: "RequestItemCellTableViewCell")
    }
    
    @objc func handleCloseTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!, category: source!)
    }
}
