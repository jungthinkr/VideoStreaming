//
//  NavigationController.swift
//  VideoStreaming
//
//  Created by Aaron Liu on 4/29/17.
//  Copyright © 2017 Aaron Liu. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        self.viewControllers = [MainMenuViewController()]
    }
    
}
