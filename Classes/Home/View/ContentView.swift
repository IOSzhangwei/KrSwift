//
//  ContentView.swift
//  krSwift
//
//  Created by 张伟 on 16/12/22.
//  Copyright © 2016年 张伟. All rights reserved.
//

import UIKit

protocol ContentViewDelegate : class{
    func contentView(contentView : ContentView ,progress : CGFloat, sourceIndex : Int, targetIndex : Int)
}

public let ContentCellID = "ContentCellID"

class ContentView: UIView {

    public var childVCS : [UIViewController]
    public weak var rootViewController :UIViewController?
    public var startOffsetX : CGFloat = 0
    weak var delegate : ContentViewDelegate?
    public var isSeletcd : Bool = false;
    public lazy var collectionView : UICollectionView = { [weak self] in
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self!.bounds.size)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero , collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
        
    }()
    
    
    init(frame: CGRect ,childVCS :[UIViewController] , rootViewController :UIViewController?) {
        
        self.childVCS = childVCS;
        self.rootViewController = rootViewController
        super.init(frame:frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}


extension ContentView {
    public func createUI(){
        
        for childVC in childVCS{
            
            rootViewController?.addChildViewController(childVC)
        }
        
        addSubview(collectionView)
        collectionView.frame = bounds
        
        
    }
}
//CollectionViewDataSource
extension ContentView :UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCS.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        let childVC = childVCS[indexPath.item]
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        return cell
    }
    
}
// UICollectionViewDelegate
extension ContentView :UICollectionViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isSeletcd = false
       startOffsetX =  scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isSeletcd {
            return
        }
        
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        let currentOffsetX = scrollView.contentOffset.x
        
        if currentOffsetX>startOffsetX  {
            progress = currentOffsetX/scrollView.bounds.width - floor(currentOffsetX/scrollView.bounds.width)
            sourceIndex = Int(currentOffsetX/scrollView.bounds.width)
            targetIndex = sourceIndex + 1
            if targetIndex >= childVCS.count {
                targetIndex = childVCS.count - 1
            }
            if currentOffsetX  - startOffsetX == scrollView.bounds.width{
                progress = 1
                targetIndex = sourceIndex
            }
            
        }else{
            progress = 1 -  (currentOffsetX/scrollView.bounds.width - floor(currentOffsetX/scrollView.bounds.width))
            targetIndex = Int(currentOffsetX/scrollView.bounds.width)
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVCS.count{
                sourceIndex = childVCS.count - 1
            }
        }
        
        delegate?.contentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        
    }
    
}


extension ContentView{
    func setCurrentIndex(currentIndex :Int) {
        //记录点击切换
        isSeletcd = true
        
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX,y:0), animated: false)
    
        
    }
}

