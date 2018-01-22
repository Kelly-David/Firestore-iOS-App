//
//  ViewController5.swift
//  foalarmApp
//
//  Created by David Kelly on 21/01/2018.
//  Copyright © 2018 davidkelly. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firestore

class ViewController5: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var db:Firestore?
    
    @IBOutlet weak var alarmsTable: UITableView!
    
    var alarmArray:[Alarm] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        checkForUpdates()
    }
    
    func loadData() {
        db = Firestore.firestore()
        
        db?.collection("alarms")
            .order(by: "createdAt", descending: true)
            .limit(to: 10).getDocuments()
                { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for item in querySnapshot!.documents {
                            
                            self.alarmArray.append(Alarm(
                            createdAt:item.data()["createdAt"] as! Date,
                            deleted:item.data()["deleted"] as! Bool,
                            displayName:item.data()["displayName"] as! String,
                            emailAddress:item.data()["emailAddress"] as! String,
                            id:item.data()["id"] as! String,
                            ownerUID:item.data()["ownerUID"] as! String,
                            phone:item.data()["phone"] as! String,
                            power:item.data()["power"] as! String,
                            state:item.data()["state"] as! Bool,
                            updatedAt:item.data()["updatedAt"] as! Date
                            ))
                            DispatchQueue.main.async {
                                self.alarmsTable.reloadData()
                            }
                        }
                    }
        }
    }
    
    func checkForUpdates() {
        db = Firestore.firestore()
        db?.collection("alarms").whereField("createdAt", isGreaterThan: Date() )
            .addSnapshotListener {
                querySnapshot, error in
                
                guard let snapshot = querySnapshot else { return }
                
                snapshot.documentChanges.forEach {
                    item in
                    
                    if item.type == .added {
                        DispatchQueue.main.async {
                            self.alarmArray.removeAll()
                            self.loadData()
                        }
                        
                    }
                }
        }
    }
    
    // Setting up table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as! ViewControllerAlertTableViewCell
        
        let alarm = alarmArray[indexPath.row]
        
        cell.alertCellTitle.text = alarm.displayName
        cell.alertCellId.text = alarm.id
        cell.alertCellSubtitle.text = alarm.phone
        cell.alertCellSubtitle2.text = alarm.emailAddress
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gotoAlerts(_ sender: UIBarButtonItem) {
    
        performSegue(withIdentifier: "segueAlarmsToAlert", sender: self)
    }
    @IBAction func logout(_ sender: UIBarButtonItem) {
    
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "segueAlarmsToLogout", sender: self)
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
