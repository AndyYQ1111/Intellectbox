//
//  UIButton+Extension.swift
//  百味迹忆
//
//  Created by YueAndy on 2017/6/16.
//  Copyright © 2017年 YueAndy. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(title : String?,imageName : String?, titleSize : CGFloat) {
        self.init(type: .custom)
        if title != nil {
            setTitle(title, for: .normal)
        }
        
        if imageName != nil {
            let img = UIImage.init(named: imageName!)
            setImage(img, for: .normal)
        }
        
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: titleSize)
        sizeToFit()
    }
    
    //图片在上面文字在下面的按钮
    func imgUp() {
        let offset:CGFloat = 16.0
        
        self.adjustsImageWhenHighlighted = false

        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(self.imageView?.bounds.width)!, bottom: -(self.imageView?.bounds.height)! - offset/2, right: 0)

        self.imageEdgeInsets = UIEdgeInsets(top: -(self.titleLabel?.intrinsicContentSize.height)! - offset/2, left: 0, bottom: 0, right: -(self.titleLabel?.intrinsicContentSize.width)!)
    }
    
    //图片在右边文字在左边的按钮
    func imgRight()  {
        let imageWidth:CGFloat = (self.imageView?.bounds.width)! + 5
        let labelWidth:CGFloat = (self.titleLabel?.bounds.width)!
        
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth, bottom: 0, right: -labelWidth)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: imageWidth)
    }
}
