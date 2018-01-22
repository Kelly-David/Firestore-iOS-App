//
//  ViewController2.swift
//  foalarmApp
//
//  Created by David Kelly on 20/01/2018.
//  Copyright © 2018 davidkelly. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Firestore

class ViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var db:Firestore?
    
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var myTableView: UITableView!
    
    var mylist:[String] = []
    var testList:[iosTest] = []
    
    @IBAction func savebtn(_ sender: UIButton) {
        
        db = Firestore.firestore()
        
        let ref = db?.collection("iosTest").document()
        
        if myTextField.text != "" {
            let createdAt = Date()
            ref?.setData(["id": ref?.documentID, "name": myTextField.text, "createdAt": createdAt])
            myTextField.text = ""
        }
    }
    
    // Setting up table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        let todo = testList[indexPath.row]
        
        cell.textLabel?.text = todo.name
        return cell
    }
    
    
    //    @IBAction func action(_ sender: Any) {
//        
//        try! Auth.auth().signOut()
//        performSegue(withIdentifier: "segue2", sender: self)
//    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "segue2", sender: self)
    }
    
    @IBAction func profile(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segueMainToProfile", sender: self)
    }
    
    @IBAction func gotoAlerts(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "seguevc2ToAlerts", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let email = Auth.auth().currentUser?.email!
        print(email!)
        loadData()
        checkForUpdates()
        
    }
    
    func loadData() {
        db = Firestore.firestore()
        
        db?.collection("iosTest").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for item in querySnapshot!.documents {
                        
                    self.testList.append(iosTest(
                        id: item.data()["id"] as! String,
                        name: item.data()["name"] as! String,
                        createdAt: item.data()["createdAt"] as! Date))
                    DispatchQueue.main.async {
                        self.myTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func checkForUpdates() {
        db = Firestore.firestore()
        db?.collection("iosTest").whereField("createdAt", isGreaterThan: Date() )
            .addSnapshotListener {
                querySnapshot, error in
                
                guard let snapshot = querySnapshot else { return }
                
                snapshot.documentChanges.forEach {
                    item in
                    
                    if item.type == .added {
                        
//                        item.document.data().values.forEach {
//                            val in
//                            if let value = val as? String {
//                                self.mylist.append(value)
//                            }
//                        }
                        // let data = item.document.data().values as? String
                        self.testList.append(iosTest(
                            id: item.document.data()["id"] as! String,
                            name: item.document.data()["name"] as! String,
                            createdAt: item.document.data()["createdAt"] as! Date))
                        DispatchQueue.main.async {
                            self.myTableView.reloadData()
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
