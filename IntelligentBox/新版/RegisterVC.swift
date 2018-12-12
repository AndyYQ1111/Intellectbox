//
//  RegisterVC.swift
//  IntelligentBox
//
//  Created by YueAndy on 2018/12/6.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

import UIKit

class RegisterVC: BaseViewController {
    
    @IBOutlet weak var tf_phonenum: UITextField!
    @IBOutlet weak var tf_code: UITextField!
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_pw: UITextField!
    @IBOutlet weak var btn_reg: UIButton!
    @IBOutlet weak var btn_icon: UIButton!
    
    var editTF:UITextField?
    //键盘启点Y
    var keyboardY:CGFloat = 0
    //键盘出现动画需要的时间
    var duration:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        releaseNotification()
    }
    // MARK: -显示密码
    @IBAction func showPW(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        tf_pw.isSecureTextEntry = !sender.isSelected
    }
    // MARK: -获取验证码
    @IBAction func getCodeAction(_ sender: UIButton) {
        
    }
}

extension RegisterVC {
    @objc override func setupUI() {
        self.tfSytle()
        btn_reg.layer.cornerRadius = 22
        btn_icon.layer.cornerRadius = 46
        self.title = "注册"
        registerNotification()
    }
    
    func tfSytle() {
        tf_phonenum.addBorder(side: .bottom, thickness: 0.5, color: UIColor.lightGray)
        tf_code.addBorder(side: .bottom, thickness: 0.5, color: UIColor.lightGray)
        tf_name.addBorder(side: .bottom, thickness: 0.5, color: UIColor.lightGray)
        tf_pw.addBorder(side: .bottom, thickness: 0.5, color: UIColor.lightGray)
    }
    
    //MARK:监听键盘通知
    func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(node:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //MARK:键盘通知相关操作
    @objc func keyBoardWillShow(node:Notification){
        //1.获取动画执行的时间
        duration =  node.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! Double
        //2. 获取键盘最终的Y值
        let endFrame = (node.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        keyboardY = endFrame.origin.y

        let win = UIApplication.shared.keyWindow
        
        let rect = editTF?.convert((editTF?.bounds)!, to: win)
        //正在编辑的控件的位置
        let y2 = (rect?.origin.y)! + (rect?.size.height)!
    
        UIView.animate(withDuration: duration) {
            if(self.keyboardY >= y2) {
                self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            }else{
                self.view.transform = CGAffineTransform(translationX: 0, y: self.keyboardY-y2-10)
            }
        }
    }

    //MARK:释放键盘监听通知
    func releaseNotification(){
        NotificationCenter.default.removeObserver(self)
    }
}

extension RegisterVC:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) // became first responder
    {
        editTF = textField
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
