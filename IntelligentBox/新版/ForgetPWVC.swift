//
//  ForgetPWVC.swift
//  IntelligentBox
//
//  Created by YueAndy on 2018/12/6.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

import UIKit

class ForgetPWVC: BaseViewController {

    @IBOutlet weak var tf_phonenum: UITextField!
    @IBOutlet weak var tf_code: UITextField!
    @IBOutlet weak var tf_pw1: UITextField!
    @IBOutlet weak var tf_pw2: UITextField!
    
    @IBOutlet weak var btn_besure: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension ForgetPWVC{
    override func setupUI()  {
        tfSytle()
        title = "忘记密码"
        btn_besure.layer.cornerRadius = 22
    }
    
    func tfSytle() {
        tf_phonenum.addBorder(side: .bottom, thickness: 0.5, color: UIColor.lightGray)
        tf_code.addBorder(side: .bottom, thickness: 0.5, color: UIColor.lightGray)
        tf_pw1.addBorder(side: .bottom, thickness: 0.5, color: UIColor.lightGray)
        tf_pw2.addBorder(side: .bottom, thickness: 0.5, color: UIColor.lightGray)
    }
}
