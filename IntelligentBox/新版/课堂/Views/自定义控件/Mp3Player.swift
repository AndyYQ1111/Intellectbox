//
//  MusicPlayer.swift
//  IntelligentBox
//
//  Created by YueAndy on 2018/12/11.
//  Copyright © 2018年 Zhuhia Jieli Technology. All rights reserved.
//

import UIKit

@IBDesignable
class Mp3Player: UIView {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var btn_play: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var lab_max: UILabel!
    
    @IBOutlet weak var lab_min: UILabel!
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable
    var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialFromXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialFromXib()
    }

    func initialFromXib() {
        let nib = UINib(nibName: "Mp3Player", bundle: Bundle.main)
        contentView = (nib.instantiate(withOwner: self, options: nil).first as! UIView)
        contentView.frame = bounds
        addSubview(contentView)
        slider.setThumbImage(UIImage(named: "icon_point"), for: .normal)
    }
}
