//
//  Colors.swift
//  PolyDraw
//
//  Created by Cote, Louis-David on 2017-04-20.
//  Copyright © 2017 Chris Chadillon. All rights reserved.
//

import UIKit

class Color : RawRepresentable{
    var rawValue: self.RawValue
    
    var color:UIColor
    init(color:UIColor){
        self.color = color
    }
}

enum Colors: Color {
    case red = Color(UIColor.red)
}
