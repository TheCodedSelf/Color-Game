//
//  AboutViewController.swift
//  ColorGame
//
//  Created by Keegan on 1/19/16.
//  Copyright © 2016 Keegan Rush. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func awakeFromNib() {
        self.setViewControllerTitle("About \(Utilities.appName())")
    }
}
