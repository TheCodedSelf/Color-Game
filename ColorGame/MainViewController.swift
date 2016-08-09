//
//  MainViewController
//  ColorGame
//
//  Created by Keegan on 1/19/16.
//  Copyright © 2016 Keegan Rush. All rights reserved.
//

import UIKit
import iAd
class MainViewController: UIViewController {
    var timer: NSTimer!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var startButton: ColorGameButton!
    @IBOutlet weak var upgradesButton: ColorGameButton!
    @IBOutlet weak var aboutButton: ColorGameButton!
    var firstRun = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(26)]
        pointsLabel.text = "\(AppManager.sharedInstance().currentPoints) points out of 100,000"
    }
    
    override func awakeFromNib() {
        setViewControllerTitle("Color Game")
        let backButton = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        navigationController!.navigationBar.barStyle = .Black;
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(MainViewController.timerTick), userInfo: nil, repeats: true)
        
        InAppPurchasesManager.sharedInstance().initialiseInViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timerTick()
        {
        var color1: UIColor? = startButton.buttonColor
        var color2: UIColor? = upgradesButton.buttonColor
        var color3: UIColor? = aboutButton.buttonColor
        
        if !firstRun
            {
                color1 = startButton.buttonColor
                color2 = upgradesButton.buttonColor
                color3 = aboutButton.buttonColor
                firstRun = true
            }
            
           
            
            var newColor1 = getNewColor(color1)
            let newColor2 = getNewColor(color2)
            var newColor3 = getNewColor(color3)
            
            while ((newColor1 == newColor2) || (newColor1 == newColor3))
                {
                    newColor1 = getNewColor(color1)
                }
            
            while ((newColor3 == newColor2) || (newColor3 == newColor1))
                {
                    newColor3 = getNewColor(color3)
                }
            
            startButton.buttonColor = newColor1
            upgradesButton.buttonColor = newColor2
            aboutButton.buttonColor = newColor3
        }
    
        func getNewColor(oldColor: UIColor?) -> UIColor
            {
                var randomNumber = Int(arc4random_uniform(6))
                var newColor = GameViewController.colors()[randomNumber]
                while newColor == oldColor
                {
                    randomNumber = Int(arc4random_uniform(6))
                    newColor = GameViewController.colors()[randomNumber]
                }
                return newColor
        }


}

