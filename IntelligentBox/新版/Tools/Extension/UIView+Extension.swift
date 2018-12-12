//
//  UIView+Extension.swift
//  THSmart
//
//  Created by YueAndy on 2018/3/28.
//  Copyright © 2018年 pingan. All rights reserved.
//

import UIKit
extension UIView {
    //设置渐变背景
    func setGradualBackground(cgColors:[CGColor])  {
        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = cgColors
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        //设置其CAGradientLayer对象的frame，并插入view的layer
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
