//
//  ViewController.swift
//  foalarmApp
//
//  Created by David Kelly on 20/01/2018.
//  Copyright © 2018 davidkelly. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var actionButton: UIButton!
    
    @IBAction func action(_ sender: Any) {
        
        // Check user has filled in fields
        if emailText.text != "" && passwordText.text != "" {
            
            // Check the segment
            if segmentControl.selectedSegmentIndex == 0 { // Login user
                
                Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!, completion: {(user, error) in
                    if user != nil {
                        
                        // Sign in sucessful
                        self.performSegue(withIdentifier: "segueMainToAlerts", sender: self)
                        
                    } else { 
                        if let myerror = error?.localizedDescription {
                            print("Sign in error: \(myerror)")
                        } else {
                            print("Sign in error")
                        }
                    }
                })
                
            } else { // Sign up user
                
                Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
                    if user != nil {
                        
                        // Create user sucessful
                        self.performSegue(withIdentifier: "segue", sender: self)
                        
                    } else {
                        if let myerror = error?.localizedDescription {
                            print("Sign in error: \(myerror)")
                        } else {
                            print("Sign in error")
                        }
                    }
                })
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

