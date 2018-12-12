//
//  PhotoCenter.swift
//  THSmart
//
//  Created by YueAndy on 2018/4/3.
//  Copyright © 2018年 pingan. All rights reserved.
//

import UIKit

class PhotoCenter: NSObject {
    
    typealias callBack = (_ image:UIImage) -> Void
    
    var finishCallBack:callBack!
    
    static let shared = PhotoCenter()

    func chooseImg() {
        let alertC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action0 = UIAlertAction(title: "拍照", style: .default) { (action) in
            let imgPickC = UIImagePickerController()
            imgPickC.delegate = self
            imgPickC.allowsEditing = true
            imgPickC.sourceType = .camera
            Global.shared.currentViewController()?.present(imgPickC, animated: true, completion: nil)
        }
        let action1 = UIAlertAction(title: "相册", style: .default) { (action) in
            let imgPickC = UIImagePickerController()
            imgPickC.delegate = self
            imgPickC.allowsEditing = true
            imgPickC.sourceType = .photoLibrary
            Global.shared.currentViewController()?.present(imgPickC, animated: true, completion: nil)
        }
        let action2 = UIAlertAction(title: "取消", style: .cancel) { (action) in
            return
        }
        alertC.addAction(action0)
        alertC.addAction(action1)
        alertC.addAction(action2)
        
        Global.shared.currentViewController()?.present(alertC, animated: true, completion: {
        })
    }
}

extension PhotoCenter:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        Global.shared.currentViewController()?.dismiss(animated: true, completion: {
            Global.shared.currentViewController()?.tabBarController?.tabBar.isHidden = true
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as! String
        if mediaType == "public.image" {
            let img = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as! UIImage
            self.finishCallBack(img)
        }
        
        Global.shared.currentViewController()?.dismiss(animated: true, completion: {
            Global.shared.currentViewController()?.tabBarController?.tabBar.isHidden = true
        })
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
