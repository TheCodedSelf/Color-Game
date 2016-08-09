//
//  UIViewController+Extensions.swift
//  ColorGame
//
//  Created by Keegan on 1/19/16.
//  Copyright © 2016 Keegan Rush. All rights reserved.
//

import UIKit

extension UIViewController
    {
    func setViewControllerTitle(title: String)
        {
        self.navigationItem.title = title
        self.title = title
        }
    }