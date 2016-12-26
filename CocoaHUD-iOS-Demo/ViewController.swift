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

    
    @IBOutlet weak var styleSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func showLoading() {
        if styleSwitch.isOn {
            CocoaHUD.show(.loading, style: .light, title: "Loading", in: imageView, hideAfter: 3)
        } else {
            CocoaHUD.show(.loading, style: .dark, title: "Loading", in: imageView, hideAfter: 3)
        }
    }
    @IBAction func showSuccess() {
        if styleSwitch.isOn {
            CocoaHUD.show(.success, style: .light, title: "Done", in: imageView, hideAfter: 3)
        } else {
            CocoaHUD.show(.success, style: .dark, title: "Done", in: imageView, hideAfter: 3)
        }
    }
    
    @IBAction func showFailure() {
        if styleSwitch.isOn {
            CocoaHUD.show(.failure, style: .light, title: "Failed", in: imageView, hideAfter: 3)
        } else {
            CocoaHUD.show(.failure, style: .dark, title: "Failed", in: imageView, hideAfter: 3)
        }
    }
    
}

