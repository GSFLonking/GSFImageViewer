//
//  ViewController.swift
//  GSFImageViewer
//
//  Created by wwa-ios-taione on 2018/12/11.
//  Copyright © 2018 com.163.ws2103916. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let imageViewer = GSFImageViewer(frame: CGRect(x: 200, y: 100, width: 100, height: 100))
        self.view.addSubview(imageViewer)
    }

    
}

