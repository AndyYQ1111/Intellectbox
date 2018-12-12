//
//  LoginVC.swift
//  IntelligentBox
//
//  Created by YueAndy on 2018/12/6.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

import UIKit

class LoginVC: BaseViewController {
    @IBOutlet weak var tf_pw: UITextField!
    @IBOutlet weak var tf_acount: UITextField!
    @IBOutlet weak var btn_login: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.navigationBar.isHidden = false
    }
    @IBAction func regAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(RegisterVC(), animated: true)
    }
    @IBAction func forgetPWAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(ForgetPWVC(), animated: true)
    }
}


extension LoginVC{
    override func setupUI()  {
        tfSytle()
        title = "登录"
        btn_login.layer.cornerRadius = 22
    }
    
    func tfSytle() {
        tf_acount.addBorder(side: .bottom, thickness: 0.5, color: UIColor.lightGray)
        tf_pw.addBorder(side: .bottom, thickness: 0.5, color: UIColor.lightGray)
    }
}

extension LoginVC: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
