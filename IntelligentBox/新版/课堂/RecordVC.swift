//
//  RecordVC.swift
//  IntelligentBox
//
//  Created by YueAndy on 2018/12/11.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

import UIKit

class RecordVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true) {}
    }
}

extension RecordVC{
    override func setupUI() {
        self.modalPresentationStyle = .custom
    }
}
