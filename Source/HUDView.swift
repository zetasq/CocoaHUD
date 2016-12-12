//
//  HUDView.swift
//  CocoaHUD
//
//  Created by Zhu Shengqi on 12/12/2016.
//  Copyright © 2016 zetasq. All rights reserved.
//

import UIKit
import SnapKit

var hudViewKey = "hudViewKey"

extension UIView {
    var hudView: HUDView? {
        get {
            if let container = objc_getAssociatedObject(self, &hudViewKey) as? WeakContainer,
                let hudView = container.obj as? HUDView {
                return hudView
            } else {
                return nil
            }
        }
        set {
            if let hudView = newValue {
                objc_setAssociatedObject(self, &hudViewKey, WeakContainer(obj: hudView), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                objc_removeAssociatedObjects(self)
            }
        }
    }
}

public final class HUDView: UIVisualEffectView {
    var type: CocoaHUD.HUDType {
        didSet {
            installDynamicElements()
        }
    }
    
    var title: String {
        didSet {
            titleLabel.text = title
            arrangeUI()
        }
    }
    
    private let style: CocoaHUD.HUDStyle
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        
        return containerView
    }()
    
    private lazy var graphicView: UIView = {
        let graphicView = UIView()
        
        return graphicView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        switch self.style {
        case .light:
            titleLabel.textColor = UIColor.black
        case .dark:
            titleLabel.textColor = UIColor.white
        }
        
        titleLabel.text = self.title
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        return titleLabel
    }()
    
    private var managedContentView: UIView
    
    public init(type: CocoaHUD.HUDType, style: CocoaHUD.HUDStyle, title: String) {
        self.type = type
        self.style = style
        self.title = title
        
        var blurEffect: UIBlurEffect
        
        switch style {
        case .light:
            blurEffect = UIBlurEffect(style: .light)
        case .dark:
            blurEffect = UIBlurEffect(style: .dark)
        }
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        
        managedContentView = vibrancyEffectView.contentView
        
        super.init(effect: blurEffect)

        contentView.addSubview(vibrancyEffectView)
        vibrancyEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupUI()
    }
    
    private func setupUI() {
        layer.cornerRadius = 15
        clipsToBounds = true
        
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().offset(5)
            make.right.lessThanOrEqualToSuperview().offset(-5)
        }
        
        containerView.addSubview(graphicView)
        containerView.addSubview(titleLabel)
        
        arrangeUI()
    }
    
    private func arrangeUI() {
        if title.isEmpty {
            graphicView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
                make.width.equalTo(50)
                make.height.equalTo(50)
            }
            
            titleLabel.snp.remakeConstraints { make in
                make.top.equalTo(graphicView.snp.bottom)
                make.centerX.equalToSuperview()
                make.height.equalTo(0)
            }
        } else {
            graphicView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
                make.width.equalTo(50)
                make.height.equalTo(50)
                make.left.greaterThanOrEqualToSuperview()
                make.right.lessThanOrEqualToSuperview()
            }
            
            titleLabel.snp.remakeConstraints{ make in
                make.top.equalTo(graphicView.snp.bottom).offset(15)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
                make.left.greaterThanOrEqualToSuperview()
                make.right.greaterThanOrEqualToSuperview()
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 120, height: 120)
    }
    
    func installDynamicElements() {
        for subview in graphicView.subviews {
            subview.removeFromSuperview()
        }
        
        if let sublayers = graphicView.layer.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
        
        switch type {
        case .loading:
            let layerFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: graphicView.bounds.size)
            
            var endColor: UIColor
            switch style {
            case .light:
                endColor = UIColor.black
            case .dark:
                endColor = UIColor.white
            }
            
            let loadingLayer = LoadingLayer(frame: layerFrame, beginColor: UIColor.clear, endColor: endColor, linewidth: 3)
            graphicView.layer.addSublayer(loadingLayer)
            loadingLayer.startAnimating()
        case .success:
            break
        case .failure:
            break
        }
    }
}
