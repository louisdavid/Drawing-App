//
//  StarterViewController.swift
//  Drawing App
//
//  Created by PK on 2017-05-11.
//  Copyright © 2017 PK. All rights reserved.
//

import UIKit
import FirebaseDatabase

class StarterViewController: UIViewController {

    //var user:String = "User1"
    var ref:FIRDatabaseReference?
    var numUsers:Int64 = 1
    var totalUsers:Int64 = 0
    var uint:UInt = 0
    var newUser = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.ref = FIRDatabase.database().reference()
        
        //change view controller if there is more than one player connected
        self.uint = (self.ref?.child("NumberOfUsersOnline").observe(.value, with: { (snapshot) in
            let value = snapshot.value as? Int64
            if let c = value{
                self.numUsers = c
            }
            if(self.numUsers > 1){
                self.ref?.child("NumberOfUsersOnline").removeObserver(withHandle: self.uint)
                self.performSegue(withIdentifier: "ConnectionSegue", sender: nil)
            }
        }))!
        //check which player you are
        self.ref?.child("NumberOfUsersOnline").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? Int64
            if let c = value{
                self.numUsers = c + 1
            }
            self.ref?.child("NumberOfUsersOnline").setValue(self.numUsers)
            //Delete current User on app shutdown
            self.ref?.child("NumberOfUsersOnline").onDisconnectSetValue(self.numUsers - 1)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//Segue
extension StarterViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let theNextVC = segue.destination as! ViewController
        
        //Delete Database and fill back in the TotalUsers and NumberOfUsersOnline
        self.ref?.removeValue()
        
        //Add Info back to database
        self.ref?.child("NumberOfUsersOnline").setValue(self.numUsers)
        
        theNextVC.numUsers = self.numUsers
        //theNextVC.user = self.user
        theNextVC.ref = self.ref
    }
}
