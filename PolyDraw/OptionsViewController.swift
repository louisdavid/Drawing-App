//
//  OptionsViewController.swift
//  PolyDraw
//
//  Created by Cote, Louis-David on 2017-04-20.
//  Copyright © 2017 Chris Chadillon. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    //Pre View Data
    var options = Options()
    var shape:Int = 0
    var myParent:OptionsSavable!
    
    //Variables
    @IBOutlet weak var lineWidth: UISlider!
    @IBOutlet weak var lineColor: UISegmentedControl!
    @IBOutlet weak var filled: UISwitch!
    @IBOutlet weak var fillColor: UISegmentedControl!
    @IBOutlet weak var previewPaneView: PreviewPaneView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up options
        self.lineWidth.value = options.lineWidth
        self.lineColor.selectedSegmentIndex = options.lineColor
        self.fillColor.selectedSegmentIndex = options.fillColor
        self.fillColor.isEnabled = options.filled
        self.filled.isOn = options.filled
        
        //Preview Pane set up
        self.previewPaneView.shapeType = self.shape
        self.previewPaneView.options = Options(self.options)
        self.previewPaneView.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

//Bar Button Functions
extension OptionsViewController{
    @IBAction func save(_ sender: UIBarButtonItem) {
        self.options.lineWidth = self.lineWidth.value
        self.options.lineColor = self.lineColor.selectedSegmentIndex
        self.options.filled = self.filled.isOn
        self.options.fillColor = self.fillColor.selectedSegmentIndex
        self.myParent.saveOptions(options: self.options)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

//Slider Functions
extension OptionsViewController {
    @IBAction func lineWidthChanged(_ sender: UISlider) {
        self.previewPaneView.options.lineWidth = self.lineWidth.value
        self.previewPaneView.setNeedsDisplay()
    }
}

//Switch Functions
extension OptionsViewController {
    @IBAction func filledChanged(_ sender: UISwitch) {
        if(filled.isOn){
            fillColor.isEnabled = true
        }else{
            fillColor.isEnabled = false
        }
        self.previewPaneView.options.filled = self.filled.isOn
        self.previewPaneView.setNeedsDisplay()
    }
}

//Segmented Control functions
extension OptionsViewController {
    @IBAction func lineColorChanged(_ sender: UISegmentedControl) {
        self.previewPaneView.options.lineColor = self.lineColor.selectedSegmentIndex
        self.previewPaneView.setNeedsDisplay()
    }
    @IBAction func fillColorChanged(_ sender: UISegmentedControl) {
        self.previewPaneView.options.fillColor = self.fillColor.selectedSegmentIndex
        self.previewPaneView.setNeedsDisplay()
    }
}


