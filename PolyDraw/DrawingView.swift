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
    var theShapes = [Shape]()
    var initialPoint: CGPoint!
    var isThereAPartialShape : Bool = false
    var thePartialShape : Shape!
    var options = Options() //gets initialized by the ViewController
    var undoBtn = UIBarButtonItem()
    var user:String?
    
    var ref:FIRDatabaseReference = FIRDatabase.database().reference()
    
    override func draw(_ rect: CGRect) {
        let possibleContext = UIGraphicsGetCurrentContext()
        
        if let theContext = possibleContext {
            for aShape in self.theShapes {
                aShape.draw(theContext)
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
            self.theShapes.append(theShape)
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





