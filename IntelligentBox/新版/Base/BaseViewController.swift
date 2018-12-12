//
//  BaseViewController.swift
//  THSmart
//
//  Created by YueAndy on 2018/3/20.
//  Copyright © 2018年 pingan. All rights reserved.
//

import UIKit
import Kingfisher

/************************  屏幕尺寸  ***************************/
// 屏幕宽度

let KScreenW = UIScreen.main.bounds.size.width

// 屏幕高度

let KScreenH = UIScreen.main.bounds.size.height

// iphone X

let isIphoneX = KScreenH == 812 ? true : false

// navigationBarHeight

let KNavBarH : CGFloat = isIphoneX ? 88 : 64

// tabBarHeight

let KTabBarH : CGFloat = isIphoneX ? 49 + 34 : 49

//let rgba(r,g,b,a)

//导航栏渐变背景

let kBlueGradientColors = [UIColor(r: 255, g: 255, b: 255).cgColor,UIColor(r: 255, g: 255, b: 255).cgColor]


class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        //标题颜色
        self.navigationController?.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]
        
        self.navigationController?.navigationBar.tintColor = UIColor.black

        //设置导航栏背景图
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(gradientColors: kBlueGradientColors, size: CGSize(width: KScreenW, height: KNavBarH)), for: .default)
        
        self.navigationController?.navigationBar.barStyle = .black;
        
        self.view.backgroundColor = UIColor.init(r: 249, g: 249, b: 249)
        
        setupUI()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getTimeStr(all:Int) -> String {
        let m:Int=all % 60
        let f:Int=Int(all/60)
        var time:String=""
        if f<10{
            time="0\(f):"
        }else {
            time="\(f)"
        }
        if m<10{
            time+="0\(m)"
        }else {
            time+="\(m)"
        }
        return time
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension BaseViewController{
    @objc func setupUI()  {
    }
}


