//
//  ViewControllerAlertTableViewCell.swift
//  foalarmApp
//
//  Created by David Kelly on 21/01/2018.
//  Copyright © 2018 davidkelly. All rights reserved.
//

import UIKit
import Firestore

class ViewControllerAlertTableViewCell: UITableViewCell {

    @IBOutlet weak var alertCellTitle: UILabel!
    @IBOutlet weak var alertCellSubtitle: UILabel!
    @IBOutlet weak var alertCellCheckButton: UIButton!
    @IBOutlet weak var alertCellId: UILabel!
    @IBOutlet weak var alertCellSubtitle2: UILabel!
    
    var db: Firestore?
    
    @IBAction func alertViewed(_ sender: UIButton) {
        
        db = Firestore.firestore()
        db?.collection("alerts").document(alertCellId.text!).updateData([
            "viewed" : true
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        self.alertCellCheckButton.backgroundColor = UIColor.white
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
