//
//  DrawingView.swift
//  PolyDraw
//
//  Created by Chris Chadillon on 2017-03-02.
//  Copyright © 2017 Chris Chadillon. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DrawingView: UIView {
    
    var shapeType = 0
    var theShapes = Dictionary<Int64,Shape>()
    var initialPoint: CGPoint!
    var isThereAPartialShape : Bool = false
    var thePartialShape : Shape!
    var options = Options() //gets initialized by the ViewController
    var undoBtn = UIBarButtonItem()
    var ref:FIRDatabaseReference?  
    var lastShapeAddedID:[Int64]?
    var totalShapesAdded:Int64 = 0
    
    override func draw(_ rect: CGRect) {
        let possibleContext = UIGraphicsGetCurrentContext()
        
        var count:Int64 = 0
        var fS = false
        if let theContext = possibleContext {
        
            for i in self.theShapes {
                fS = false
                while(!fS){
                    if self.theShapes[count] != nil{
                        self.theShapes[count]?.draw(theContext)
                        fS = true
                    }
                    count += 1
                }
            }

            if self.isThereAPartialShape {
                self.thePartialShape.draw(theContext)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.isThereAPartialShape {
            let touch = touches.first! as UITouch
            self.initialPoint = touch.location(in: self)
            self.isThereAPartialShape = true
        }
        self.undoBtn.isEnabled = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let newPoint = touch.location(in: self)
        
        let topLeftPoint = CGPoint(x: self.initialPoint.x < newPoint.x ? self.initialPoint.x : newPoint.x,
                                   y: self.initialPoint.y < newPoint.y ? self.initialPoint.y : newPoint.y)
        
        if self.isThereAPartialShape {
            switch(shapeType){
            case 0: self.thePartialShape = Rect(X: Double(topLeftPoint.x),
                                                Y: Double(topLeftPoint.y),
                                                theHeight: abs(Double(self.initialPoint.y-newPoint.y)),
                                                theWidth: abs(Double(self.initialPoint.x-newPoint.x)),
                                                options: Options(options))
                break
            case 1: self.thePartialShape = Oval(X: Double(topLeftPoint.x),
                                                Y: Double(topLeftPoint.y),
                                                theHeight: abs(Double(self.initialPoint.y-newPoint.y)),
                                                theWidth: abs(Double(self.initialPoint.x-newPoint.x)),
                                                options: Options(options))
                break
            case 2,3: self.thePartialShape = Line(X: Double(self.initialPoint.x),
                                                  Y: Double(self.initialPoint.y),
                                                  theHeight: Double(newPoint.y),
                                                  theWidth: Double(newPoint.x),
                                                  options: Options(options))
                break
            default: self.thePartialShape = Rect(X: Double(topLeftPoint.x),
                                                 Y: Double(topLeftPoint.y),
                                                 theHeight: abs(Double(self.initialPoint.y-newPoint.y)),
                                                 theWidth: abs(Double(self.initialPoint.x-newPoint.x)),
                                                 options: Options(options))
                break
            }
        }
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isThereAPartialShape = false
        if let theShape = self.thePartialShape {
            let touch = touches.first! as UITouch
            let newPoint = touch.location(in: self)
            undoBtn.isEnabled = true
            
            if self.lastShapeAddedID != nil {
                self.lastShapeAddedID?.append(self.totalShapesAdded)
            }else{
                self.lastShapeAddedID = [self.totalShapesAdded]
            }
            self.ref?.child("Shapes").child("TotalShapesAdded").setValue(self.totalShapesAdded + 1)
            //Save shape with options the database under shapes/shapeid/<String,Int64>
            self.ref?.child("Shapes").child(String(describing: self.lastShapeAddedID?.last)).setValue(theShape.toDict((self.lastShapeAddedID?.last)!))

            self.thePartialShape = nil
            if(shapeType == 3){
                self.thePartialShape = Line(X: Double(newPoint.x),
                                            Y: Double(newPoint.y),
                                            theHeight: Double(newPoint.y),
                                            theWidth: Double(newPoint.x),
                                            options: Options(options))
                self.initialPoint.x = newPoint.x
                self.initialPoint.y = newPoint.y
                self.isThereAPartialShape = true
            }
        }
    }
}





