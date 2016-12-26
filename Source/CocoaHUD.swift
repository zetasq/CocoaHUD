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
    
    public static func show(_ type: HUDType, style: HUDStyle, title: String, in canvasView: UIView, hideAfter showTime: Double? = nil) {
        canvasView.isUserInteractionEnabled = false
        
        if let hudView = canvasView.hudView {
            hudView.type = type
            hudView.title = title
            
            hudView.transform = .identity
            hudView.alpha = 1
            
            hudView.installDynamicElements()
        } else {
            let hudView = HUDView(type: type, style: style, title: title)
            
            canvasView.addSubview(hudView)
            canvasView.hudView = hudView
            
            hudView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            
            hudView.layoutIfNeeded()
            hudView.installDynamicElements()
            
            hudView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            hudView.alpha = 0
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [.beginFromCurrentState], animations: {
                hudView.transform = .identity
                hudView.alpha = 1
            }, completion: nil)
        }
        
        if let showTime = showTime {
            DispatchQueue.main.asyncAfter(deadline: .now() + showTime) {
                hide(in: canvasView)
            }
        }
    }
    
    public static func hide(in canvasView: UIView, completion: (() -> Void)? = nil) {
        guard let hudView = canvasView.hudView else {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            hudView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            hudView.alpha = 0
        }) { finished in
            if finished {
                hudView.removeFromSuperview()
                canvasView.hudView = nil
            }
            completion?()
        }
    }
}
