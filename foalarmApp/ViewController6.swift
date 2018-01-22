//
//  ViewController6.swift
//  foalarmApp
//
//  Created by David Kelly on 22/01/2018.
//  Copyright © 2018 davidkelly. All rights reserved.
//

import UIKit
import Firestore

class ViewController6: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var db:Firestore?

    @IBOutlet weak var horseTable: UITableView!
    
    var horseArray:[Horse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        checkForUpdates()
    }
    
    func loadData() {
        db = Firestore.firestore()
        
        db?.collection("horses").whereField("deleted", isEqualTo: false).getDocuments()
                { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for item in querySnapshot!.documents {
                            
                            self.horseArray.append(Horse(
                                id:item.data()["id"] as! String,
                                displayName:item.data()["displayName"] as! String,
                                active:item.data()["state"] as! Bool,
                                ownerID:item.data()["ownerUID"] as! String,
                                dueDate:item.data()["dueDate"] as! String,
                                photoURL:item.data()["photoURL"] as! String
                            ))
                            DispatchQueue.main.async {
                                self.horseTable.reloadData()
                            }
                        }
                    }
        }
    }
    
    func checkForUpdates() {
        db = Firestore.firestore()
        db?.collection("horses").whereField("createdAt", isGreaterThan: Date() )
            .addSnapshotListener {
                querySnapshot, error in
                
                guard let snapshot = querySnapshot else { return }
                
                snapshot.documentChanges.forEach {
                    item in
                    
                    if item.type == .added {
                        DispatchQueue.main.async {
                            self.horseArray.removeAll()
                            self.loadData()
                        }
                        
                    }
                }
        }
    }
    
    // Setting up table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return horseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "horseCell", for: indexPath) as! ViewControllerAlertTableViewCell
        
        let horse = horseArray[indexPath.row]
        
        cell.alertCellTitle.text = horse.displayName
        cell.alertCellId.text = horse.id
        cell.alertCellSubtitle.text = horse.dueDate
        cell.alertCellSubtitle2.text = horse.ownerID
        horse.active ?
            cell.horseActiveCheckButton.backgroundColor = UIColor(red: 0, green: 0.5843, blue: 0.7176, alpha: 1.0)
            : nil
        return cell
    }
    
    
    @IBAction func gotoAlarms(_ sender: UIBarButtonItem) {
    
        performSegue(withIdentifier: "segueHorsesToAlarms", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gotoAlerts(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segueHorsesToAlerts", sender: self)
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
