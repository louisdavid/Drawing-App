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
    var ref:FIRDatabaseReference?
    var numUsers:Int64 = 0
    var uint:UInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        undoBtn.isEnabled = false
        self.drawingView.options = options
        self.drawingView.undoBtn = undoBtn
        self.drawingView.ref = self.ref
        
        //Keep track of TotalShapesAdded to create unique id
        self.ref?.child("Shapes").child("TotalShapesAdded").observe(.value, with: { (snapshot) in
            let value = snapshot.value as? Int64
            if let c = value{
                self.drawingView.totalShapesAdded = c
            }
        })
        
        //Watch for any Shapes added
        self.ref?.child("Shapes").observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let c = value{
                let shapeType = c["ShapeType"]!
                let x = c["X"]!
            }

        })

        self.uint = (self.ref?.child("NumberOfUsersOnline").observe(.value, with: { (snapshot) in
            let value = snapshot.value as? Int64
            if let c = value{
                self.numUsers = c
            }
            if(self.numUsers <= 1){
                self.ref?.child("NumberOfUsersOnline").removeObserver(withHandle: self.uint)
                self.dismiss(animated: true, completion: nil)
            }
        }))!
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
        if let _ = self.drawingView.lastShapeAddedID{
            
            self.ref?.child("Shapes").child(String(describing: self.drawingView.lastShapeAddedID?.last)).removeValue()
            self.drawingView.theShapes.removeValue(forKey: (self.drawingView.lastShapeAddedID?.last)!)
            self.drawingView.lastShapeAddedID?.popLast()!
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
