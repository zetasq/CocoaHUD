//
//  ViewController.swift
//  CocoaHUD-iOS-Demo
//
//  Created by Zhu Shengqi on 12/12/2016.
//  Copyright © 2016 zetasq. All rights reserved.
//

import UIKit
import CocoaHUD

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        CocoaHUD.show(.loading, style: .dark, title: "Loading", in: imageView)
    }
    
}

