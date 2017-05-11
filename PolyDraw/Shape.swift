//
//  Shape.swift
//  PolyDraw
//
//  Created by Chris Chadillon on 2017-03-02.
//  Copyright © 2017 Chris Chadillon. All rights reserved.
//

import UIKit

class Shape {
    var X:Double
    var Y:Double
    var options:Options
    
    init(X:Double, Y:Double) {
        self.X = X
        self.Y = Y
        self.options = Options()
    }
    init(X:Double, Y:Double, options:Options) {
        self.X = X
        self.Y = Y
        self.options = options
    }
    
    func fillOptionsInContext(context: CGContext) {
        context.setLineWidth(CGFloat(self.options.lineWidth))
        context.setStrokeColor(self.options.getLineColorAsCGColor)
        if(self.options.filled){
            context.setFillColor(self.options.getFillColorAsCGColor)
        }else{
            context.setFillColor(UIColor.clear.cgColor)
        }
    }
    
    func draw(_ theContext:CGContext){}
}





















