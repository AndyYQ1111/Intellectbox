//
//  AddPackageVC.swift
//  IntelligentBox
//
//  Created by YueAndy on 2018/12/10.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

import UIKit
import Photos


class AddPackageVC: BaseViewController {
    
    @IBOutlet weak var tf_title: UITextField!
    @IBOutlet weak var tf_des: UITextField!
    @IBOutlet weak var cv_photo: UICollectionView!
    @IBOutlet weak var btn_record: UIButton!
    @IBOutlet weak var btn_upload: UIButton!
    @IBOutlet weak var btn_done: UIButton!
    
    @IBOutlet weak var v_player: UIView!
    
    let CellID = "PhotoCell"
    
    var imageCount : Int = 0
    
    var imageArray = Array<UIImage>()
    
    var lastImageId: Int32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func recordAction(_ sender: UIButton) {
        let nextVC = RecordVC()
        nextVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.present(nextVC, animated: true) {}
    }
    @IBAction func uploadAction(_ sender: UIButton) {
        
    }
}

extension AddPackageVC {
    override func setupUI() {
        title = "新增知识包"
        btn_done.layer.cornerRadius = 22
        btn_upload.layer.cornerRadius = 15
        btn_record.layer.cornerRadius = 15
        
        cv_photo.register(UINib.init(nibName: CellID, bundle: nil), forCellWithReuseIdentifier: CellID)
    }
}

extension AddPackageVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath) as! PhotoCell
        if(indexPath.row == imageArray.count){
            cell.iv_photo.image = UIImage(named: "icon_zhishibao_tianjia")
            cell.btn_del.isHidden = true;
        }else{
            cell.iv_photo.image = imageArray[indexPath.row]
            cell.btn_del.isHidden = false;
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photo()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 100, height: 100)
    }
}

// MARK: 选取相册图片
extension AddPackageVC{
    @objc private func photo(){
        let album = JDAlbumGroupController()
        album.selectImgsClosure1 = { [weak self] (assets: [PHAsset]) in
            for index in 0..<assets.count {
                self?.getOrangeImage(asset: assets[index]) {[weak self] (data) in
                    let img = UIImage(data: (data ?? nil)!)
                    if data != nil {
                        self?.imageArray.append(img!)
                    }
                }
            }
            self?.cv_photo.reloadData()
        }
        
        let nav = UINavigationController(rootViewController: album)
        
        self.present(nav, animated: true, completion: nil)
    }
    
    typealias ImgCallBackType = (UIImage?)->()
    //获取缩略图
    private func getLitImage(asset: PHAsset,callback: @escaping ImgCallBackType){
        PHImageManager.default().requestImage(for: asset,
                                              targetSize: CGSize(width: 100, height: 100) , contentMode: .aspectFill,
                                              options: nil, resultHandler: {
                                                (image, _: [AnyHashable : Any]?) in
                                                if image != nil{
                                                    callback(image)
                                                }
                                                
        })
    }
    
    typealias ImgCallBackType1 = (Data?)->()
    //获取原图
    private func getOrangeImage(asset: PHAsset,callback: @escaping ImgCallBackType1){
        //获取原图
        
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        option.resizeMode = .exact
        
        lastImageId = PHImageManager.default().requestImageData(for: asset, options: option, resultHandler: { (data, string, up, nil) in
            if data != nil{
                callback(data)
            }
        })
    }
}

