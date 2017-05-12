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
   // var user:String?
    var ref:FIRDatabaseReference?  
    var lastShapeAddedID:[Int64]?
    var totalShapesAdded:Int64 = 0
    
    override func draw(_ rect: CGRect) {
        let possibleContext = UIGraphicsGetCurrentContext()
        
        if let theContext = possibleContext {
            for aShape in self.theShapes {
                aShape.value.draw(theContext)
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
        if let theShape = self.thePartialShape {
            let touch = touches.first! as UITouch
            let newPoint = touch.location(in: self)
            
            undoBtn.isEnabled = true
            
            //Dont append let 
            //self.theShapes[self.totalShapesAdded] = theShape
            
            if self.lastShapeAddedID != nil {
                self.lastShapeAddedID?.append(self.totalShapesAdded)
            }else{
                self.lastShapeAddedID = [self.totalShapesAdded]
            }

            self.ref?.child("Shapes").child("TotalShapesAdded").setValue(self.totalShapesAdded + 1)
            //Save shape with options the database under shapes/shapeid/<String,Int64>
            self.ref?.child("Shapes").child(String(describing: self.lastShapeAddedID?.last)).child("Shapetype").setValue(self.shapeType)
            self.ref?.child("Shapes").child(String(describing: self.lastShapeAddedID?.last!)).child("X").setValue(theShape.X)
            self.ref?.child("Shapes").child(String(describing: self.lastShapeAddedID?.last!)).child("Y").setValue(theShape.Y)
            self.ref?.child("Shapes").child(String(describing: self.lastShapeAddedID?.last!)).child("H").setValue(theShape.H)
            self.ref?.child("Shapes").child(String(describing: self.lastShapeAddedID?.last!)).child("W").setValue(theShape.W)
            self.ref?.child("Shapes").child(String(describing: self.lastShapeAddedID?.last!)).child("LineWidth").setValue(theShape.options.lineWidth)
            self.ref?.child("Shapes").child(String(describing: self.lastShapeAddedID?.last!)).child("LineColor").setValue(theShape.options.lineColor)
            self.ref?.child("Shapes").child(String(describing: self.lastShapeAddedID?.last!)).child("Filled").setValue(theShape.options.filled)
            self.ref?.child("Shapes").child(String(describing: self.lastShapeAddedID?.last!)).child("FilledColor").setValue(theShape.options.fillColor)

            if(shapeType != 3){
                self.isThereAPartialShape = false
            }else {
                self.thePartialShape = Line(X: Double(newPoint.x),
                                            Y: Double(newPoint.y),
                                            theHeight: Double(newPoint.y),
                                            theWidth: Double(newPoint.x),
                                            options: Options(options))
                self.initialPoint.x = newPoint.x
                self.initialPoint.y = newPoint.y
            }
        }else{
            self.isThereAPartialShape = false
        }
    }
}





