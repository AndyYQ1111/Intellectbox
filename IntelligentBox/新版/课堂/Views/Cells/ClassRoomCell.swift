//
//  ClassRoomCell.swift
//  IntelligentBox
//
//  Created by YueAndy on 2018/12/10.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

import UIKit

class ClassRoomCell: BaseTableViewCell {
    @IBOutlet weak var lab_title: UILabel!
    @IBOutlet weak var lab_time: UILabel!
    @IBOutlet weak var lab_des: UILabel!
    @IBOutlet weak var lab_read: UILabel!
    @IBOutlet weak var btn_more: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
