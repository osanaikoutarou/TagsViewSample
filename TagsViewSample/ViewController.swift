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
    let tags = ["aaaa","bbbb","hogehoge","あいうえお","東京特許許可局許可局長","🎉🎉🎉","あめんぼあかいなあいうえお",
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

        layout.setup(collectionView: collectionView,
                     cellType: TagCollectionViewCell.self,
                     horizontalMargin: 10,
                     verticalMargin: 10,
                     collectionViewInset: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15),
                     tags: tags)
        
        collectionView.setCollectionViewLayout(layout, animated: false)

    }
}

/// UICollectionViewのDelegateとDataSrource
extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
        cell.label1.text = tags[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let text = tags[indexPath.item]
        print(text)
    }
}


//MARK: extension

protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}

extension NSObjectProtocol {
    var describedProperty: String {
        let mirror = Mirror(reflecting: self)
        return mirror.children.map { element -> String in
            let key = element.label ?? "Unknown"
            let value = element.value
            return "\(key): \(value)"
            }
            .joined(separator: "\n")
    }
}

