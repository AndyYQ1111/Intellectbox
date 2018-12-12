//
//  Label+Extension.swift
//  百味迹忆
//
//  Created by YueAndy on 2017/6/16.
//  Copyright © 2017年 YueAndy. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(title : String, sizeFont : CGFloat , color :UIColor) {
        self.init()
        text = title
        font = UIFont.systemFont(ofSize: sizeFont)
        textColor = color
        sizeToFit()
    }
}
