//
//  ModifyPWVC.swift
//  IntelligentBox
//
//  Created by YueAndy on 2018/12/10.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

import UIKit

class ModifyPWVC: BaseViewController {

    @IBOutlet weak var tf_code: UITextField!
    @IBOutlet weak var tf_pw1: UITextField!
    @IBOutlet weak var tf_pw2: UITextField!
    @IBOutlet weak var btn_besure: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ModifyPWVC{
    override func setupUI()  {
        tfSytle()
        title = "修改密码"
        btn_besure.layer.cornerRadius = 22
    }
    
    func tfSytle() {
        
        tf_code.addBorder(side: .bottom, thickness: 0.5, color: UIColor.lightGray)
        tf_pw1.addBorder(side: .bottom, thickness: 0.5, color: UIColor.lightGray)
        tf_pw2.addBorder(side: .bottom, thickness: 0.5, color: UIColor.lightGray)
    }
}
