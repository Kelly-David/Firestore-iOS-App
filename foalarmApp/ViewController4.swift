//
//  ViewController4.swift
//  foalarmApp
//
//  Created by David Kelly on 21/01/2018.
//  Copyright © 2018 davidkelly. All rights reserved.
//

import UIKit
import Firestore
import FirebaseAuth

class ViewController4: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var db:Firestore?
    let formatter = DateFormatter()
    
    @IBOutlet weak var alertsTable: UITableView!
    
    var alertArray:[Alert] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        checkForUpdates()
    }
    
    func loadData() {
        db = Firestore.firestore()
        
        db?.collection("alerts")
            .order(by: "createdAt", descending: true)
            .limit(to: 10).getDocuments()
                { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for item in querySnapshot!.documents {
                    
                    self.alertArray.append(Alert(
                     createdAt: item.data()["createdAt"] as! Date,
                     deleted: item.data()["deleted"] as! Bool,
                     id: item.data()["id"] as! String,
                     horseId: item.data()["horseId"] as! String,
                     horseName: item.data()["horseName"] as! String,
                     owner: item.data()["owner"] as! String,
                     updateAt: item.data()["updatedAt"] as! Date,
                     viewed: item.data()["viewed"] as! Bool))
                    DispatchQueue.main.async {
                        self.alertsTable.reloadData()
                    }
                }
            }
        }
    }
    
    func checkForUpdates() {
        db = Firestore.firestore()
        db?.collection("alerts").whereField("createdAt", isGreaterThan: Date() )
            .addSnapshotListener {
                querySnapshot, error in
                
                guard let snapshot = querySnapshot else { return }
                
                snapshot.documentChanges.forEach {
                    item in
                    
                    if item.type == .added {
                        
//                        self.alertArray.append(Alert(
//                            createdAt: item.document.data()["createdAt"] as! Date,
//                            deleted: item.document.data()["deleted"] as! Bool,
//                            id: item.document.data()["id"] as! String,
//                            horseId: item.document.data()["horseId"] as! String,
//                            horseName: item.document.data()["horseName"] as! String,
//                            owner: item.document.data()["owner"] as! String,
//                            updateAt: item.document.data()["updatedAt"] as! Date,
//                            viewed: item.document.data()["viewed"] as! Bool))
                        
                        DispatchQueue.main.async {
                            self.alertArray.removeAll()
                            self.loadData()
                            //self.alertsTable.reloadData()
                        }
                        
                    }
                }
        }
        //alertArray = alertArray.sorted(by: { $0.createdAt < $1.createdAt })
    }
    
    // Setting up table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) as! ViewControllerAlertTableViewCell
        
        let alert = alertArray[indexPath.row]
        
        cell.alertCellTitle.text = alert.horseName
        
        let myStringafd = dateToString(alertDate: alert.createdAt)
        
        cell.alertCellSubtitle.text = myStringafd
        cell.alertCellId.text = alert.id
        
        if alert.viewed == false {
            cell.alertCellCheckButton.backgroundColor = UIColor(red: 0.6392, green: 0, blue: 0.2118, alpha: 1.0)
        }
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dateToString(alertDate: Date) -> String {
        
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: alertDate)
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        
        return myStringafd
        
    }
    
    @IBAction func gotoAlarms(_ sender: UIBarButtonItem) {
    
        performSegue(withIdentifier: "segueAlertsToAlarms", sender: self)
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "segueAlertsToLogout", sender: self)
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
