//
//  ViewController3.swift
//  foalarmApp
//
//  Created by David Kelly on 20/01/2018.
//  Copyright © 2018 davidkelly. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import Firestore

class ViewController3: UIViewController {
    
    var db:Firestore?
    var currentUser:User?
    var userId:String?
    
    @IBOutlet weak var labelUserDisplayName: UILabel!
    @IBOutlet weak var labelUserEmail: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    
    // To Login View
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "segueProfileToOut", sender: self)
    }
    
    // To Alert View
    @IBAction func alerts(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "segueProfileToMain", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userId = Auth.auth().currentUser?.uid
        db = Firestore.firestore()
        
        db?.collection("users").whereField("uid", isEqualTo: userId!)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for item in querySnapshot!.documents {
                        
                        self.labelUserDisplayName.text = item.data()["fullName"] as? String
                        self.labelUserEmail.text = item.data()["email"] as? String
                        
                        DispatchQueue.main.async {
                            self.labelUserEmail.reloadInputViews()
                            self.labelUserDisplayName.reloadInputViews()
                        }
                    }
                }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
