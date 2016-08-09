//
//  VideoViewController.swift
//  ColorGame
//
//  Created by Keegan on 1/19/16.
//  Copyright © 2016 Keegan Rush. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController {

    @IBOutlet weak var pointsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        pointsLabel.text = "\(AppManager.sharedInstance().currentPoints) points"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func awakeFromNib() {
        self.setViewControllerTitle("Earn Free Points")
    }

}
