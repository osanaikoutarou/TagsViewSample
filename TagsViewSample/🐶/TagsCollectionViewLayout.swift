//
//  TagsCollectionViewLayout.swift
//  TagsViewSample
//
//  Created by 長内幸太郎 on 2018/10/13.
//  Copyright © 2018年 長内幸太郎. All rights reserved.
//

import UIKit

private extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type,
                                                             for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
    }
}

protocol HasLabelCollectionViewCell: UICollectionViewCell {
    var label: UILabel { get }
}

class TagsCollectionViewLayout: UICollectionViewFlowLayout {
    
    var cellFrames:[IndexPath:CGRect] = [:]
    
    var cellSizes:[CGSize] = []
    var collectionViewWidth:CGFloat = UIScreen.main.bounds.width
    var horizontalMargin:CGFloat = 0
    var verticalMargin:CGFloat = 0
    var collectionViewInset:UIEdgeInsets = .zero
    
    func resetAll() {
        cellSizes = []
        cellFrames = [:]
    }
    
    func setup<T: HasLabelCollectionViewCell>(collectionView: UICollectionView,
                                              cellType: T.Type,
                                              horizontalMargin:CGFloat,
                                              verticalMargin:CGFloat,
                                              collectionViewInset:UIEdgeInsets,
                                              tags: [String]) {
        
        resetAll()
        
        self.horizontalMargin = horizontalMargin
        self.verticalMargin = verticalMargin
        self.collectionViewInset = collectionViewInset

        let dummyCell = collectionView.dequeueReusableCell(with: cellType, for: IndexPath(item: 0, section: 0))
        
        tags.forEach { (str) in
            // cellの期待width
            let expectedCellWidth = str.width(withConstrainedHeight: dummyCell.label.frame.height,
                                              font: dummyCell.label.font)
            // cellの期待Size
            cellSizes.append(CGSize(width: expectedCellWidth + TagCollectionViewCell.inset.left + TagCollectionViewCell.inset.right,
                                    height: dummyCell.label.frame.height + TagCollectionViewCell.inset.top + TagCollectionViewCell.inset.bottom))
        }
        
        calcLayout()
        
    }
    /// レイアウトを指定,左上詰めで計算する
    ///
    /// - Parameters:
    ///   - cellSizes:左上から順のサイズ
    ///   - horizontalMargin: cell同士のmargin 上下
    ///   - verticalMargin: cell同士のmargin 左右
    ///   - collectionViewInset: 全体のInset
    private func calcLayout() {
        
        // 左上から並べていきます
        
        var currentPoint:CGPoint = CGPoint(x: collectionViewInset.top, y: collectionViewInset.left)
        var currentRowHeight:CGFloat = 1
        
        for (i, size) in cellSizes.enumerated() {
            let indexPath = IndexPath(row: i, section: 0)
            
            if (currentPoint.x + size.width <= collectionViewWidth - collectionViewInset.left - collectionViewInset.right) {
                // 収まる
                let frame = CGRect(x: currentPoint.x, y: currentPoint.y, width: size.width, height: size.height)
                cellFrames[indexPath] = frame
                
                if (currentRowHeight < size.height) {
                    currentRowHeight = size.height
                }
                currentPoint.x += size.width + horizontalMargin
            }
            else {
                // 改行したうえで
                currentPoint.x = collectionViewInset.left
                currentPoint.y += currentRowHeight + verticalMargin
                currentRowHeight = 1
                
                if (currentPoint.x + size.width <= collectionViewWidth - collectionViewInset.left - collectionViewInset.right) {
                    // 収まる
                    let frame = CGRect(x: currentPoint.x, y: currentPoint.y, width: size.width, height: size.height)
                    cellFrames[indexPath] = frame
                    
                    if (currentRowHeight < size.height) {
                        currentRowHeight = size.height
                    }
                    currentPoint.x += size.width + horizontalMargin
                }
                else {
                    // 収まらない
                    currentPoint = CGPoint(x: 0, y: currentPoint.y + verticalMargin + currentRowHeight)
                    currentRowHeight = 1
                    
                    let frame = CGRect(x: currentPoint.x,
                                       y: currentPoint.y,
                                       width: collectionViewWidth,
                                       height: size.height)
                    cellFrames[indexPath] = frame
                    
                    if (currentRowHeight < size.height) {
                        currentRowHeight = size.height
                    }
                    currentPoint.x = collectionViewInset.left
                }
            }
        }
    }
    
    // 引数で指定されたNSIndexPathに対応する装飾要素のレイアウト情報を返すメソッドです。
    // DecorationViewとは、特定のデータに紐づかず、単にUIの見た目をよくするために配置されるビジュアルエレメントのことを意味します。
    // DecorationViewについては別の機会に触れたいと思います。
    // 作成するカスタムレイアウトがDecorationViewをサポートしない場合は、このメソッドを実装する必要はありません。
    //    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    //    }
    
    // UICollectionViewのコンテンツがスクロールされると、現在表示されているコンテンツ領域の位置情報を引数にこのメソッドが呼び出されます。
    // このメソッドでは、更新された位置情報からレイアウト処理を再実行すべきか判断して真偽値を返します。
    // ここでYESを返すとinvalideteLayoutメソッドを呼び出したのと同じ扱いになるようです。
    //    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    //    }
    
    // UICollectionView内の要素を配置するコンテンツ部のサイズを返すメソッドです。
    // UIScrollViewのcontentSizeプロパティと同じく、スクロール領域の範囲をコントロールします。
    override var collectionViewContentSize: CGSize {
        
        var maxY:CGFloat = 0
        cellFrames.forEach {
            if ($0.value.maxY > maxY ) {
                maxY = $0.value.maxY
            }
        }
        
        return CGSize(width: collectionViewWidth, height: maxY + collectionViewInset.bottom)
    }
    
    
    
    //MARK:----
    
    // UICollectionViewLayoutAttributesクラスは
    // Collection View上の各Cellのレイアウト情報（大きさ、座標、α値などの属性情報）をCellに紐付けて取り扱いやすいようにまとめたクラスです。
    
    
    // 引数で指定されたNSIndexPathに対応する要素のレイアウト情報を返すメソッドです。
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.attributes(indexPath:indexPath)
    }
    
    
    
    // 引数で渡されたCGRectの範囲内に表示される要素のUICollectionViewLayoutAttributesの配列を返すメソッドです。
    // 一部分しか表示されていない要素もこのメソッドで返します。
    // このメソッドでの戻り値でUICollectionViewLayoutAttributesが返されない要素は画面上に表示されないことから、
    // UICollectionView内部ではこのメソッドの戻り値の情報を利用して、現在の表示領域周辺のみセルなどの要素を配置しているものと思われます。
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var result:[UICollectionViewLayoutAttributes] = []
        for key in self.cellFrames.keys {
            let frame = self.cellFrames[key]
            if (rect.intersects(frame!)) {
                result.append(self.attributes(indexPath: key))
            }
        }
        
        return result
    }
    
    
    // 引数で指定されたNSIndexPathに対応する補助要素のレイアウト情報を返すメソッドです。
    // SupplementaryViewはデータをUIで表現する際に補助的な役割を果たすビジュアルエレメントのことを指します。
    // UICollectionViewFlowLayoutではSupplementaryViewとしてヘッダとフッタが用意されています。
    // このメソッドの第一引数でどちらの要素であるかを示す定数値が渡されてきますので、対応する要素のレイアウト情報を返すよう実装します。
    // 作成するカスタムレイアウトがSupplementaryViewをサポートしない場合は、このメソッドを実装する必要はありません。
    // なお、あくまでSupplementaryViewとしてヘッダとフッタを定義しているのはUICollectionViewFlowLayoutの仕様のようです。
    // 現に、ヘッダとフッタを示す定数である、UICollectionElementKindSectionHeaderとUICollectionElementKindSectionFooterはUICollectionViewFlowLayout.hで定義されています。
    // これらのことから考えるSupplementaryViewはいわゆるヘッダやフッタである必要はなく、実装者の自由に定義されることが想定されているようです。
    //    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    //    }
    
}

private extension TagsCollectionViewLayout {
    func attributes(indexPath:IndexPath) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = self.cellFrames[indexPath] ?? .zero
        return attributes
    }
    
}

private extension String {
    // 幅を計算する
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}
