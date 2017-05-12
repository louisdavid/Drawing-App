//
//  Rect.swift
//  PolyDraw
//
//  Created by Chris Chadillon on 2017-03-02.
//  Copyright © 2017 Chris Chadillon. All rights reserved.
//

import UIKit

class Rect:Shape {

    var theHeight:Double
    var theWidth:Double
    
    init(X:Double, Y:Double, theHeight:Double, theWidth:Double) {
        self.theHeight = theHeight
        self.theWidth = theWidth
        super.init(X: X, Y: Y)
    }
    init(X:Double, Y:Double, theHeight:Double, theWidth:Double, options:Options) {
        self.theHeight = theHeight
        self.theWidth = theWidth
        super.init(X: X, Y: Y, options: options)
    }
    
    override func draw(_ theContext: CGContext) {
        let rect = CGRect(x: self.X, y: self.Y, width: self.theWidth, height: self.theHeight)
        fillOptionsInContext(context: theContext)
        theContext.addRect(rect)
        theContext.fillPath()
        theContext.addRect(rect)
        theContext.strokePath()
    }
    override func toDict(_ key:Int64) -> [String : Any] {
        var dict = super.toDict(key)
        dict["H"] = self.theHeight
        dict["W"] = self.theWidth
        dict["ShapeType"] = 0
        return dict
    }
}

















