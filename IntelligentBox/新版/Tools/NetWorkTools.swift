//
//  NetWorkTools.swift
//  DYZB
//
//  Created by YueAndy on 2017/10/24.
//  Copyright © 2017年 YueAndy. All rights reserved.
//

import UIKit
import Alamofire
let KCurrentView = Global.shared.currentViewController()?.view

enum HttpType {
    case GET
    case POST
}

class NetWorkTools {
    class func requestData(method : HttpType , urlString : String , paraDic : [String : Any]? = nil , finishCallBack:@escaping (_ result : AnyObject) -> ()) {

        let urlString = "http://thzn_td_app.100memory.com/" + urlString

        let type = method == .GET ? HTTPMethod.get : HTTPMethod.post

        Alamofire.request(urlString ,method: type ,parameters:paraDic).validate().responseJSON { response in
            switch response.result {
            case .success:
                finishCallBack(response.result.value as AnyObject)
            case .failure(let error):
                print(error.localizedDescription)
                KCurrentView?.makeToast("网络不给力")
            }
        }
    }
}
