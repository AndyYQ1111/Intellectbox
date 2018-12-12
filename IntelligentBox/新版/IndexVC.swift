//
//  IndexVC.swift
//  IntelligentBox
//
//  Created by YueAndy on 2018/12/6.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

import UIKit

class IndexVC: BaseViewController {
    
    @IBOutlet weak var btn_reg: UIButton!
    @IBOutlet weak var btn_login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.navigationBar.isHidden = true
        hideNavBar()
    }
    
    @IBAction func regAction(_ sender: UIButton) {
//        self.navigationController?.pushViewController(RegisterVC(), animated: true)
        self.navigationController?.pushViewController(ClassRoomVC(), animated: true)
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(LoginVC(), animated: true)
    }
}


extension IndexVC{

    override func setupUI() {
        btn_login.layer.cornerRadius = 5.0
        btn_login.layer.borderWidth = 1
        btn_login.layer.borderColor = UIColor.white.cgColor

        btn_reg.layer.cornerRadius = 5.0
        btn_reg.layer.borderWidth = 1
        btn_reg.layer.borderColor = UIColor.white.cgColor
    }
    func hideNavBar(){
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//
//        self.navigationController?.navigationBar.barStyle = .blackOpaque
//
//        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}
