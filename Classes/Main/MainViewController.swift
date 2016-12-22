//
//  MainViewController.swift
//  krSwift
//
//  Created by 张伟 on 16/12/21.
//  Copyright © 2016年 张伟. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildVC("Home")
         addChildVC("Discover")
         addChildVC("Follow")
         addChildVC("User")
        
    }
    
    private func addChildVC(_ storyName : String){
        
        let childVC = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        
        addChildViewController(childVC)
        
    }

 

}
