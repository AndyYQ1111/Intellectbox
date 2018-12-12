//
//  UIBarButtonItem+Extension.swift
//  百味迹忆
//
//  Created by YueAndy on 2017/6/16.
//  Copyright © 2017年 YueAndy. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(title : String,imageName: String = "left_select_img", titleSize : CGFloat = 16,target: Any? , action: Selector) {
        let btn = UIButton(title: title, imageName: imageName, titleSize: titleSize)
        btn.addTarget(target, action: action, for: .touchUpInside)
        self.init(customView: btn)
    }
}
