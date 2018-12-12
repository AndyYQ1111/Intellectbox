//
//  ClassRoomVC.swift
//  IntelligentBox
//
//  Created by YueAndy on 2018/12/10.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

import UIKit

class ClassRoomVC: BaseViewController {
    
    @IBOutlet weak var t_course: UITableView!
    
    let classCellID = "ClassRoomCell"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.navigationBar.isHidden = false
    }
}

extension ClassRoomVC {
    
    override func setupUI() {
        title = "课堂"
        addRightItem()
        t_course .register(UINib.init(nibName: classCellID, bundle: nil), forCellReuseIdentifier: classCellID)
    }
    
    //添加自定义导航栏
    func addRightItem() {
        let shareBtn = UIButton(title: "", imageName: "icon_ketang_fenxiang", titleSize: 9)
        shareBtn.frame = CGRect(x: 4, y: 0, width: 40, height: 20)
        shareBtn.addTarget(self, action: #selector(rightItemClick), for: .touchUpInside)
        let shareItem = UIBarButtonItem(customView: shareBtn)
        
        let addBtn = UIButton(title: "", imageName: "icon_ketang_tianjia", titleSize: 9)
        addBtn.frame = CGRect(x: 4, y: 0, width: 20, height: 20)
        addBtn.addTarget(self, action: #selector(rightItemClick), for: .touchUpInside)
        let addItem = UIBarButtonItem(customView: addBtn)
        
        self.navigationItem.rightBarButtonItems = [addItem,shareItem]
    }
    
    @objc func rightItemClick() {
        self.navigationController?.pushViewController(AddPackageVC(), animated: true)
    }
}

extension ClassRoomVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: classCellID, for: indexPath) as! ClassRoomCell
        cell.btn_more.tag = indexPath.row
        cell.btn_more.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 205
    }
    
    @objc func moreAction(sender:UIButton) {
        let alertC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "编辑", style: .default) { (UIAlertAction) in
            
        }
        let delAction = UIAlertAction(title: "删除", style: .default) { (UIAlertAction) in
            
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
            
        }
        
        alertC.addAction(editAction)
        alertC.addAction(delAction)
        alertC.addAction(cancelAction)
        
        self.present(alertC, animated: true) {
            
        }
    }
    
}
