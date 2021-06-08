//
//  TagCollectionViewCell.swift
//  TagsViewSample
//
//  Created by 長内幸太郎 on 2018/10/14.
//  Copyright © 2018年 長内幸太郎. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label1: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.bounds.height/2.0
        self.clipsToBounds = true
    }

}

/// TagsCollectionViewLayoutに適用する
extension TagCollectionViewCell: TagCollectionViewCellProrocol {
    var label: UILabel {
        return label1
    }
    
    var insets: UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
}
