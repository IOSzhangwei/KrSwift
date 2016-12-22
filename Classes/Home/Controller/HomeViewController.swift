//
//  HomeViewController.swift
//  krSwift
//
//  Created by 张伟 on 16/12/21.
//  Copyright © 2016年 张伟. All rights reserved.
//

import UIKit



let WIDTH = UIScreen.main.bounds.size.width
let HEIGHT = UIScreen.main.bounds.size.height

class HomeViewController: UIViewController {

    public lazy var titleView : TitleView = {[weak self] in
       let frame = CGRect(x: 0, y: 0, width: 230, height: 44)
        let titles = ["快讯","推荐","早期项目"]
        let titleView = TitleView(frame: frame, titles: titles)
        titleView.delegate = self
        return titleView;
    }()
    
    public lazy var contentView :ContentView = {[weak self] in
        let  contentFrame = CGRect(x: 0, y: 44, width: WIDTH, height: HEIGHT)
        
        var childVCS = [UIViewController]()
        for _ in 0..<3{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.init(r:CGFloat(arc4random_uniform(255)) , g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVCS.append(vc)
        }
        
        let contentView = ContentView(frame: contentFrame, childVCS: childVCS, rootViewController: self)
        contentView.delegate = self
        return contentView;
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        createUI()
        
        view.addSubview(contentView)
        contentView.backgroundColor = UIColor.red
    }


}

//create UI
extension HomeViewController{
    
    
    
    public func createUI(){
        setupNavigationBar()
        
    }
    
    
    private func setupNavigationBar(){
        navigationItem.titleView = titleView;
        
    }
}

//titleView  delegate
extension HomeViewController : TitleViewDelegate{
    func titleView(titleView: TitleView, seletedIndex index: Int) {
        contentView.setCurrentIndex(currentIndex: index)
    }
}

//contentView delegate
extension HomeViewController : ContentViewDelegate{
    func contentView(contentView: ContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleViewWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

