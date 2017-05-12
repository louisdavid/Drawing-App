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
            let value = snapshot.value as? [String:Any]
            if let c = value {
                if let dict = c as? [String:Any] {
                    if let options = dict["Options"] as? [String:Any]{
                        
                        let lw = options["LineWidth"] as! Float
                        let lc = options["LineColor"] as! Int
                        let f = options["Filled"] as! Bool
                        let fc = options["FilledColor"] as! Int
                        let st = dict["ShapeType"] as! Int
                        let option = Options(lineWidth: lw, lineColor: lc,  filled: f, fillColor: fc)
                        var ashape:Shape?
                        
                        switch st {
                        case 0:
                            ashape = Rect(X: dict["X"] as! Double, Y: dict["Y"] as! Double, theHeight: dict["H"] as! Double, theWidth: dict["W"] as! Double, options: option)
                        case 1:
                            ashape = Oval(X: dict["X"] as! Double, Y: dict["Y"] as! Double, theHeight: dict["H"] as! Double, theWidth: dict["W"] as! Double, options: option)
                        case 2,3:
                            ashape = Line(X: dict["X"] as! Double, Y: dict["Y"] as! Double, theHeight: dict["H"] as! Double, theWidth: dict["W"] as! Double, options: option)
                        default:
                            ashape = Rect(X: dict["X"] as! Double, Y: dict["Y"] as! Double, theHeight: dict["H"] as! Double, theWidth: dict["W"] as! Double, options: option)
                        }
                        self.drawingView.theShapes[self.drawingView.totalShapesAdded - 1] = ashape
                        self.drawingView.setNeedsDisplay()
                    }
                }
            }

        })
        self.ref?.child("Shapes").observe(.childRemoved, with: { (snapshot) in
            let value = snapshot.value as? [String:Any]
            if let c = value {
                let key = c["Key"] as! Int64
                self.drawingView.theShapes.removeValue(forKey: key)
                self.drawingView.setNeedsDisplay()
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
            self.ref?.child("Shapes").child(String(describing: self.drawingView.lastShapeAddedID?.popLast())).removeValue()
            if(self.drawingView.shapeType == 3){
                self.drawingView.isThereAPartialShape = false
            }
            if ((self.drawingView.lastShapeAddedID?.isEmpty) == true ?? (self.drawingView.lastShapeAddedID == nil)) {
                undoBtn.isEnabled = false
            }
            self.drawingView.setNeedsDisplay()
        }
    }
}
