//
//  ViewController.swift
//  PolyDraw
//
//  Created by Chris Chadillon on 2017-03-02.
//  Copyright © 2017 Chris Chadillon. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, OptionsSavable {

    var options = Options()
    @IBOutlet weak var drawingView: DrawingView!
    @IBOutlet weak var undoBtn: UIBarButtonItem!
    var user:String = "User1"
    var ref:FIRDatabaseReference?
    var numUsers:Int64 = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        undoBtn.isEnabled = false
        self.drawingView.options = options
        self.drawingView.undoBtn = undoBtn
        self.drawingView.ref = self.ref
        
        
        self.ref?.child("Users").observe(.childRemoved, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let _ = value{
                self.ref?.child("NumberOfUsersOnline").observeSingleEvent(of: .value, with: { (snapshot) in
                    let val = snapshot.value as? Int64
                    if let c = val {
                        self.numUsers = c - 1
                    }
                    self.ref?.child("NumberOfUsersOnline").setValue(self.numUsers)
                    if(self.numUsers <= 1){
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        })
    }
}

//Segue
extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let theNextViewController = segue.destination as! OptionsViewController
        theNextViewController.shape = drawingView.shapeType
        theNextViewController.options = options
        theNextViewController.myParent = self
    }
}

//SegmentedIndex Functions
extension ViewController {
    @IBAction func shapeChosen(_ sender: UISegmentedControl) {
        self.drawingView.shapeType = sender.selectedSegmentIndex
        self.drawingView.isThereAPartialShape = false
    }
}

//OptionsSavable function
extension ViewController {
    func saveOptions(options:Options){
        self.options = options
        self.drawingView.options = options
    }
}

//Button Functions
extension ViewController {
    @IBAction func undo(_ sender: UIBarButtonItem) {
        if let _ = self.drawingView.theShapes.popLast(){
            if(self.drawingView.shapeType == 3){
                self.drawingView.isThereAPartialShape = false
            }
            if self.drawingView.theShapes.isEmpty {
                undoBtn.isEnabled = false
            }
            self.drawingView.setNeedsDisplay()
        }
    }
}
