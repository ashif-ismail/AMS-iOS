//
//  RequestItemCellTableViewCell.swift
//  AMS
//
//  Created by DOT Developer DOT on 05/01/2020.
//  Copyright © 2020 Doodle. All rights reserved.
//

import UIKit

class RequestItemCellTableViewCell: UITableViewCell {

    @IBOutlet weak var bgCard: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var submittedBy: UILabel!
    @IBOutlet weak var requestSubject: UILabel!
    @IBOutlet weak var txtRequestID: UILabel!
    @IBOutlet weak var txtCreatedOn: UILabel!
    @IBOutlet weak var txtModifiedOn: UILabel!
    @IBOutlet weak var txtHR: UILabel!
    @IBOutlet weak var txtCeo: UILabel!
    @IBOutlet weak var txtCM: UILabel!
    @IBOutlet weak var headerModified: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.submittedBy.text = ""
        self.requestSubject.text = ""
        self.txtCeo.text = ""
        self.txtHR.text = ""
        self.txtCM.text = ""
        self.txtRequestID.text = ""
        self.txtCreatedOn.text = ""
        self.txtModifiedOn.text = ""
    }
    
}
