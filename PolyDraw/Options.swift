//
//  Options.swift
//  PolyDraw
//
//  Created by Cote, Louis-David on 2017-04-20.
//  Copyright © 2017 Chris Chadillon. All rights reserved.
//

import UIKit

class Options {

    var lineWidth:Float
    var lineColor:Int
    var filled:Bool
    var fillColor:Int
    
    init(){
        self.lineWidth = 1
        self.lineColor = 0
        self.filled = true
        self.fillColor = 1
    }
    
    init(lineWidth:Float, lineColor:Int,  filled:Bool, fillColor:Int){
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.filled = filled
        self.fillColor = fillColor
    }
    
    init(_ options:Options){
        self.lineWidth = options.lineWidth
        self.lineColor = options.lineColor
        self.filled = options.filled
        self.fillColor = options.fillColor
    }
    
    var getLineColorAsCGColor:CGColor {
        switch(self.lineColor){
        case 0: return UIColor.red.cgColor
        case 1: return UIColor.green.cgColor
        case 2: return UIColor.blue.cgColor
        case 3: return UIColor.orange.cgColor
        case 4: return UIColor.purple.cgColor
        case 5: return UIColor.black.cgColor
        case 6: return UIColor.brown.cgColor
        default: return UIColor.gray.cgColor
        }
    }
    var getFillColorAsCGColor:CGColor {
        switch(self.fillColor){
        case 0: return UIColor.red.cgColor
        case 1: return UIColor.green.cgColor
        case 2: return UIColor.blue.cgColor
        case 3: return UIColor.orange.cgColor
        case 4: return UIColor.purple.cgColor
        case 5: return UIColor.black.cgColor
        case 6: return UIColor.brown.cgColor
        default: return UIColor.gray.cgColor
        }
    }
}
