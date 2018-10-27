//
//  ViewController.swift
//  TagsViewSample
//
//  Created by 長内幸太郎 on 2018/10/13.
//  Copyright © 2018年 長内幸太郎. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let texts = ["aaaa","bbbb","hogehoge","あいうえお","東京特許許可局許可局長","🎉🎉🎉","あめんぼあかいなあいうえお",
                 "aaaa","bbbb","hogehoge","あいうえお","東京特許許可局","🎉🎉","あめんぼあかいなあいうえお",
                 "aaaa","bbbb","hogehoge","あいうえお","東京","🎉🎉🎉","あめんぼ",
                 "aaaa","bbbb","hogehoge","あいうえお","東京","🎉🎉","あめんぼあかいなあいうえお",
                 "aaaa","bbbb","hogehoge","あいうえお","東京特許許可局許可局長","🎉🎉🎉","あめんぼあかいなあいうえお",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupLayout()
    }
    
    func setupLayout() {
        let layout = TagsCollectionViewLayout()

        var cellSizes:[CGSize] = []
        let dummyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: IndexPath(row: 0, section: 0)) as! TagCollectionViewCell
        texts.forEach { (str) in
            // cellの期待width
            let expectedCellWidth = str.width(withConstrainedHeight: dummyCell.label1.frame.height,
                                              font: dummyCell.label1.font)
            // cellの期待Size
            cellSizes.append(CGSize(width: expectedCellWidth + TagCollectionViewCell.inset.left + TagCollectionViewCell.inset.right,
                                    height: dummyCell.label1.frame.height + TagCollectionViewCell.inset.top + TagCollectionViewCell.inset.bottom))
        }
        
        layout.setup(cellSizes: cellSizes,
                     horizontalMargin: 10,
                     verticalMargin: 10,
                     collectionViewInset: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        
        collectionView.setCollectionViewLayout(layout, animated: false)

    }
}

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return texts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
        cell.label1.text = texts[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let text = texts[indexPath.item]
        print(text)
    }
}

// MARK: extensions

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    // 幅を計算する
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

