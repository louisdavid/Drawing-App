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
    var userKey:String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //if options were saved previously
        // options = saved options
        self.drawingView.options = options
        undoBtn.isEnabled = false
        self.drawingView.undoBtn = undoBtn
        
        self.ref = FIRDatabase.database().reference()
        
        //check which player you are
        self.ref?.child("Users").child("1").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? String
            if let _ = value{
                self.userKey = "2"
                self.user = "User2"
                self.ref?.child("Users").child("2").setValue(self.user)
            }else{
                self.ref?.child("Users").child("1").setValue(self.user)
            }
            //Delete current User on app shutdown
            self.ref?.child("Users").child(self.userKey).onDisconnectRemoveValue()
        })
        //Delete shapes database
        self.ref?.child("Shapes").removeValue()
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
