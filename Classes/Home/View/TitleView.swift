//
//  TitleView.swift
//  krSwift
//
//  Created by 张伟 on 16/12/21.
//  Copyright © 2016年 张伟. All rights reserved.
//

import UIKit

protocol TitleViewDelegate :class {
    
    func titleView(titleView :TitleView,seletedIndex index:Int)
    
}

public let KrNormalColor : (CGFloat,CGFloat,CGFloat) = (143,145,157)
public let KrSelectColor : (CGFloat,CGFloat,CGFloat) = (34,35,38)

class TitleView: UIView {

    public var currentIndex : Int = 0
    public var titles : [String]
    public lazy var titleLabels :[UILabel] = [UILabel]()
    
    weak var delegate : TitleViewDelegate?
    
    public lazy var scrollView :UIScrollView = {
       
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false;
        scrollView.bounces = false
        
        return scrollView
    }()
    
    public lazy var scrollLine :UIView = {
       
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.red
        return scrollLine
    }()
    
    
    init(frame: CGRect,titles :[String]) {
        
        self.titles = titles
        super.init(frame :frame)
        createUI();
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}


extension TitleView{
    public func createUI(){
        
        addSubview(scrollView)
        scrollView.frame = bounds
        scrollView.backgroundColor = UIColor.clear
        
        setTitles()
        scrollView.addSubview(scrollLine)
        
        guard let firstLabel  = titleLabels.first else {
            return
        }
        firstLabel.textColor = UIColor(colorLiteralRed: 34.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x , y: frame.height - 2, width: firstLabel.frame.width, height: 2)
    }
    
    private func setTitles(){
        
        let labelW :CGFloat = frame.width/CGFloat(titles.count)
        let labelH :CGFloat = frame.height - 2
        let labelY :CGFloat = 0
        
        for(index,title) in titles.enumerated(){
            let label = UILabel ()
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 15)
            label.textColor = UIColor(r: KrNormalColor.0, g: KrNormalColor.1, b: KrNormalColor.2)
            label.textAlignment = .center
            let labelX :CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH);
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(_:)))
            label .addGestureRecognizer(tapGes)
        }
    }
}

extension TitleView{
    @objc public func titleLabelClick(_ tapGes :UITapGestureRecognizer){
        
        
        guard let currentLabel = tapGes.view as? UILabel else {
            return
        }
        
        let oldLabel = titleLabels[currentIndex]
        
        currentLabel.textColor = UIColor(r: KrSelectColor.0, g: KrSelectColor.1, b: KrSelectColor.2)
        oldLabel.textColor = UIColor(r: KrNormalColor.0, g: KrNormalColor.1, b: KrNormalColor.2);
        
        currentIndex = currentLabel.tag
        
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        
        UIView.animate(withDuration: 0.15) { 
            self.scrollLine.frame.origin.x = scrollLineX
        }
        delegate?.titleView(titleView: self, seletedIndex: currentIndex)
    }
}

extension TitleView{
    func setTitleViewWithProgress(progress : CGFloat,sourceIndex : Int,targetIndex : Int)  {
        
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        let moveTotalX =  targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
         let coloDelta = (KrSelectColor.0 - KrNormalColor.0,KrSelectColor.1 - KrNormalColor.1,KrSelectColor.2 - KrNormalColor.2)
        sourceLabel.textColor = UIColor(r: KrSelectColor.0 - coloDelta.0 * progress, g: KrSelectColor.1 - coloDelta.1 * progress, b: KrSelectColor.2 - coloDelta.2 * progress)
       
        targetLabel.textColor = UIColor(r: KrNormalColor.0 + coloDelta.0 * progress, g: KrNormalColor.1 + coloDelta.1 * progress, b: KrNormalColor.2 + coloDelta.2 * progress)
        
        if progress == 0 {
            targetLabel.textColor = UIColor(r: KrSelectColor.0, g: KrSelectColor.1, b: KrSelectColor.2)
        }
        
        currentIndex = targetIndex

    }
}
