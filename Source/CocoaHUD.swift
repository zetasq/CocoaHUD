//
//  HUD.swift
//  CocoaHUD
//
//  Created by Zhu Shengqi on 12/12/2016.
//  Copyright © 2016 zetasq. All rights reserved.
//

import UIKit
import SnapKit

public final class CocoaHUD {
    public enum HUDType {
        case loading
        case success
        case failure
    }
    
    public enum HUDStyle {
        case light
        case dark
    }
    
    private init() {}
    
    public static func show(_ type: HUDType, style: HUDStyle, title: String, in canvasView: UIView) {
        canvasView.isUserInteractionEnabled = false
        
        let hudView = HUDView(type: type, style: style, title: title)
        canvasView.addSubview(hudView)
        
        hudView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        hudView.layoutIfNeeded()
        hudView.installDynamicElements()
        
        hudView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        hudView.alpha = 0.5
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: [.beginFromCurrentState], animations: {
            hudView.transform = .identity
            hudView.alpha = 1
        }, completion: nil)
    }
}
