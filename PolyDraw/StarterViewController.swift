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

    var user:String = "User1"
    var ref:FIRDatabaseReference?
    var numUsers:Int64 = 1
    var totalUsers:Int64 = 1
    var uint:UInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.ref = FIRDatabase.database().reference()
        
        //get TotalUsers
        self.ref?.child("TotalUsers").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Int64
            if let c = value{
                self.totalUsers = c + 1
            }
            self.ref?.child("TotalUsers").setValue(self.totalUsers)
        })
        
        
        //change view controller if another player connects
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
                self.user = "User" + String(self.totalUsers)
            }
            self.ref?.child("Users").child(self.user).child("User").setValue(self.user)
            self.ref?.child("NumberOfUsersOnline").setValue(self.numUsers)
            //Delete current User on app shutdown
            self.ref?.child("Users").child(self.user).onDisconnectRemoveValue()
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
        theNextVC.numUsers = self.numUsers
        theNextVC.user = self.user
        theNextVC.ref = self.ref
        
        //get TotalUsers
        self.ref?.child("TotalUsers").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Int64
            if let c = value{
                self.totalUsers = c
            }
        })
        self.ref?.removeValue()
        self.ref?.child("NumberOfUsersOnline").setValue(self.numUsers)
        self.ref?.child("TotalUsers").setValue(self.totalUsers)
    }
}
