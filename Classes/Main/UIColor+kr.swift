//
//  UIColor+kr.swift
//  krSwift
//
//  Created by 张伟 on 16/12/22.
//  Copyright © 2016年 张伟. All rights reserved.
//

import UIKit

extension UIColor{
    
    convenience init(r :CGFloat, g :CGFloat, b:CGFloat) {
        
        
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    }
    
    
}
