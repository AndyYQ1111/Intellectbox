//
//  BaseNavC.swift
//  THSmart
//
//  Created by YueAndy on 2018/3/20.
//  Copyright © 2018年 pingan. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // 重写 所有的 push 方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 如果不是栈底控制器才需要隐藏，根控制器不需要处理
        if(children.count > 0){
            // 隐藏底部的 TabBar
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
