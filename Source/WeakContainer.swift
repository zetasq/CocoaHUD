//
//  WeakContainer.swift
//  CocoaHUD
//
//  Created by Zhu Shengqi on 14/12/2016.
//  Copyright © 2016 zetasq. All rights reserved.
//

import Foundation

final class WeakContainer {
    weak var obj: AnyObject?
    
    init(obj: AnyObject) {
        self.obj = obj
    }
}
