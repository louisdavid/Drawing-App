//  PreviewPaneView.swift
//  PolyDraw
//
//  Created by Cote, Louis-David on 2017-04-21.
//  Copyright © 2017 Chris Chadillon. All rights reserved.
//

import UIKit

class PreviewPaneView: UIView {
    var shapeType = 0
    var options = Options()
    var width = 0.0
    var height = 0.0
    let padding = 20.0
    
    override func draw(_ rect: CGRect) {
        self.width = Double(self.bounds.width)
        self.height = Double(self.bounds.height)
        var theShape:Shape
        
        switch shapeType {
        case 0: theShape = Rect(X: padding, Y: padding, theHeight: height - padding - padding, theWidth: width - padding - padding, options: Options(options))
            break
        case 1: theShape = Oval(X: padding, Y: padding, theHeight: height - padding - padding, theWidth: width - padding - padding, options: Options(options))
            break
        case 2,3: theShape = Line(X: padding, Y: padding, theHeight: height - padding, theWidth: width - padding, options: Options(options))
            break
        default: theShape = Rect(X: padding, Y: padding, theHeight: height - padding - padding, theWidth: width - padding - padding, options: Options(options))
            break
        }
        let context = UIGraphicsGetCurrentContext()
        theShape.draw(context!)
    }
}
