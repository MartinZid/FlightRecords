//
//  CustomPrintPageRenderer.swift
//  FlightRecords
//
//  Created by Martin Zid on 24/01/2018.
//  Copyright © 2018 Martin Zid. All rights reserved.
//

import UIKit

class CustomPrintPageRenderer: UIPrintPageRenderer {
    
    let A4PageWidth: CGFloat = 595.2
    
    let A4PageHeight: CGFloat = 841.8
    
    override init() {
        super.init()
        let pageFrame = CGRect(x: 0.0, y: 0.0, width: A4PageWidth, height: A4PageHeight)
        self.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
        self.setValue(NSValue(cgRect: pageFrame), forKey: "printableRect")
        //self.setValue(NSValue(cgRect: CGRect.insetBy(CGRect(x: 10, y: 10, width: 0, height: 0))), forKey: "printableRect")
    }
}
