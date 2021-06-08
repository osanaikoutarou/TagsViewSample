//
//  TagCollectionViewCell.swift
//  TagsViewSample
//
//  Created by 長内幸太郎 on 2018/10/14.
//  Copyright © 2018年 長内幸太郎. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell, HasLabelCollectionViewCell {
    
    @IBOutlet weak var label1: UILabel!
        
    // storyboardと合わせる(4つの値を取得するのがやや面倒なので)
    static var inset:UIEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.bounds.height/2.0
        self.clipsToBounds = true
    }
    
    var label: UILabel {
        return label1
    }

}

