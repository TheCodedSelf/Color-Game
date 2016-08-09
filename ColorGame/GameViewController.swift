//
//  GameViewController.swift
//  ColorGame
//
//  Created by Keegan on 1/19/16.
//  Copyright © 2016 Keegan Rush. All rights reserved.
//

import UIKit
import iAd
import AVKit

class GameViewController: UIViewController, ADInterstitialAdDelegate {
    @IBOutlet weak var button1: ColorGameButton!
    @IBOutlet weak var button2: ColorGameButton!
    @IBOutlet weak var button3: ColorGameButton!
    @IBOutlet weak var button4: ColorGameButton!
    @IBOutlet weak var button5: ColorGameButton!
    @IBOutlet weak var button6: ColorGameButton!
    
    @IBOutlet weak var pieChart: UIView!
    
    @IBOutlet weak var pointsGainedLabel: UILabel!
    @IBOutlet weak var currentColorLabel: UILabel!
    @IBOutlet weak var currentPointsLabel: UILabel!
    @IBOutlet weak var pointsMultiplierLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var gameTimer: NSTimer!
    var firstGame = true
    var timeRing: CAShapeLayer!
    var winStreak = 0
    var gameLength: CGFloat = 3
    let maxGameLength: CGFloat = 3
    var secondsRemaining: CGFloat!
    var gameIsRunning = true
    let colorsByName = ["RED" : UIColor.redColor(), "YELLOW" : UIColor.yellowColor(), "GREEN" : UIColor.greenColor(), "PURPLE" : UIColor.purpleColor(), "BLUE" : UIColor.blueColor(), "ORANGE" : UIColor.orangeColor()]
    let namesByColor = [UIColor.redColor() : "RED", UIColor.yellowColor() : "YELLOW", UIColor.greenColor() : "GREEN", UIColor.purpleColor() : "PURPLE", UIColor.blueColor() : "BLUE", UIColor.orangeColor() : "ORANGE"]
    class func colors() -> Array<UIColor> {return [UIColor.redColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.purpleColor(), UIColor.blueColor(), UIColor.orangeColor()]}
    
    let pointsIncrement = 1
    let timeDecrement: CGFloat = 0.5
    let minTime: CGFloat = 1
    override func awakeFromNib()
        {
        self.setViewControllerTitle("Color Game")
        }

    override func viewDidLoad()
        {
        button1.buttonColor = colorsByName["RED"]!
        button2.buttonColor = colorsByName["YELLOW"]!
        button3.buttonColor = colorsByName["GREEN"]!
        button4.buttonColor = colorsByName["PURPLE"]!
        button5.buttonColor = colorsByName["BLUE"]!
        button6.buttonColor = colorsByName["ORANGE"]!
        
        pointsGainedLabel.textColor = timeLabel.textColor
        currentPointsLabel.textColor = timeLabel.textColor
        pointsMultiplierLabel.textColor = timeLabel.textColor
        updatePointsLabel()
        drawPieChart()
        }
    
    
    func updatePointsLabel()
        {
    currentPointsLabel.text = "\(AppManager.sharedInstance().currentPoints) points out of 100,000"
    }
    
    @IBAction func button1Tap(sender: AnyObject) {
    processRound((sender as! ColorGameButton))
    }
    
    @IBAction func button2Tap(sender: AnyObject) {
    processRound((sender as! ColorGameButton))
    }
    
    @IBAction func button3Tap(sender: AnyObject) {
    processRound((sender as! ColorGameButton))
    }
    
    @IBAction func button4Tap(sender: AnyObject) {
    processRound((sender as! ColorGameButton))
    }
    
    @IBAction func button5Tap(sender: AnyObject) {
    processRound((sender as! ColorGameButton))
    }
    
    @IBAction func button6Tap(sender: AnyObject) {
    processRound((sender as! ColorGameButton))
    }
    
    func processRound(button: ColorGameButton?)
        {
        let win = button != nil && button!.buttonColor == colorsByName[currentColorLabel.text!]
        win ? roundWon() : roundLost()
        }
    
    func roundWon()
        {
        var pointsForCurrentRound = ((maxGameLength - gameLength)*2) + CGFloat(pointsIncrement)
        if AppManager.sharedInstance().pointsMultiplierRounds > 0
            {
            pointsForCurrentRound *= 2
            }
        AppManager.sharedInstance().currentPoints += Int(pointsForCurrentRound)
        updatePointsLabel()
        
        pointsGainedLabel.text = "+\(Int(pointsForCurrentRound))"
        pointsGainedLabel.hidden = false
        pointsGainedLabel.alpha = 1.0
        UIView.animateWithDuration(2, animations: {self.pointsGainedLabel.alpha = 0})
        
        if gameLength > minTime
            {
             gameLength -= timeDecrement
            }
            
        let points = AppManager.sharedInstance().currentPoints
        let oldPoints = points - Int(pointsForCurrentRound)
        
        let roundUpTo500 = roundUp(oldPoints, divisor: 500)
        if (points > roundUpTo500) && roundUpTo500 > 499
            {
            loadInterstitialAd()
            }
        else
            {
            newGame()
            }
        }
    
    func roundLost()
        {
        gameLength = maxGameLength
        newGame()
        }
    
    override func viewWillAppear(animated: Bool) {
        gameIsRunning = true
        newGame()
    }
    
    override func viewDidDisappear(animated: Bool) {
        gameIsRunning = false
    }
    
    func newGame()
        {
        if gameIsRunning == false
            {
            if gameTimer != nil
                {gameTimer.invalidate()
            gameTimer = nil
            }
            return
            }
        
        self.secondsRemaining = self.gameLength
        dispatch_async(dispatch_get_main_queue(), {[unowned self] in
            
            let x = CGFloat((self.secondsRemaining / self.gameLength))
            self.timeRing.strokeEnd = x
            self.timeLabel.text = "\(Int(ceil(self.secondsRemaining)))"
        })
        
        var currentColor: UIColor?
        var currentBackgroundColor: UIColor?
        var currentColorForText: UIColor?
        
        var newBackgroundColor: UIColor!
        var newColor: UIColor!
        var newColorForText: UIColor!
        
        if !firstGame
            {
            currentColorForText = currentColorLabel.textColor
            currentBackgroundColor = view.backgroundColor
            currentColor = colorsByName[currentColorLabel.text!]
            }
        else
            {
            firstGame = false
            }
            
        var randomNumber = Int(arc4random_uniform(6))
        newColor = GameViewController.colors()[randomNumber]
        while newColor == currentColor
            {
            randomNumber = Int(arc4random_uniform(6))
            newColor = GameViewController.colors()[randomNumber]
            }
            
        randomNumber = Int(arc4random_uniform(6))
        newColorForText = GameViewController.colors()[randomNumber]
        while newColorForText == newColor || newColorForText == currentColorForText
            {
                randomNumber = Int(arc4random_uniform(6))
                newColorForText = GameViewController.colors()[randomNumber]
            }
            
        randomNumber = Int(arc4random_uniform(6))
        newBackgroundColor = GameViewController.colors()[randomNumber]
        
        while newColor == newBackgroundColor || newBackgroundColor == currentBackgroundColor || newColorForText == newBackgroundColor
            {
            randomNumber = Int(arc4random_uniform(6))
            newBackgroundColor = GameViewController.colors()[randomNumber]
            }
            
        currentColorLabel.textColor = newColorForText
        currentColorLabel.text = namesByColor[newColor]
        view.backgroundColor = newBackgroundColor
        
        startTimer()
        
        if AppManager.sharedInstance().pointsMultiplierRounds > 0
            {
                pointsMultiplierLabel.text = "Points multipler active for \(AppManager.sharedInstance().pointsMultiplierRounds) rounds"
                pointsMultiplierLabel.hidden = false
                AppManager.sharedInstance().pointsMultiplierRounds -= 1
            }
        else
            {
                pointsMultiplierLabel.hidden = true
            }
        }
    
        func startTimer()
            {
            if gameTimer != nil
                {
                gameTimer.invalidate()
                gameTimer = nil
                }
            gameTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "timerTick", userInfo: nil, repeats: true)
            }
    
        func timerTick()
            {
//                dispatch_async(dispatch_get_main_queue(), {[unowned self] in
                    self.secondsRemaining = self.secondsRemaining - 0.25
                    let x = (CGFloat(self.secondsRemaining) / CGFloat(self.gameLength))
                    self.timeRing.strokeEnd = x
                    self.timeLabel.text = "\(Int(ceil(self.secondsRemaining)))"
                    if self.secondsRemaining <= 0
                    {
                        self.stopTimer()
                    }
//                    })
            
            }
            
        func stopTimer()
            {
            processRound(nil)
            }
    
    func drawPieChart()
        {
            // Create a white ring that fills the entire frame and is 2 points wide.
            // Its frame is inset 1 point to fit for the 2 point stroke width
            let radius = min(pieChart.frame.size.width,pieChart.frame.size.height)/2
            let inset: CGFloat  = 2
            timeRing = CAShapeLayer()
            timeRing.path = UIBezierPath(roundedRect: CGRectInset(pieChart.bounds, inset, inset), cornerRadius: radius-inset).CGPath
            
            timeRing.fillColor   = UIColor.clearColor().CGColor
            timeRing.strokeColor = timeLabel.textColor.CGColor
            timeRing.lineWidth   = 4
            pieChart.layer.addSublayer(timeRing)
        }
    
    
    var interstitialAd:ADInterstitialAd!
    var interstitialAdView: UIView = UIView()
    
    func loadInterstitialAd() {
        interstitialAd = ADInterstitialAd()
        interstitialAd.delegate = self
        gameTimer.invalidate()
        gameTimer = nil
    }
    
    func interstitialAdWillLoad(interstitialAd: ADInterstitialAd!) {
        
    }
    
    func interstitialAdDidLoad(interstitialAd: ADInterstitialAd!) {
        interstitialAdView = UIView()
        interstitialAdView.frame = self.view.bounds
        let v = UIViewController()
        v.view = interstitialAdView
        self.navigationController?.pushViewController(v, animated: true)
//        view.addSubview(interstitialAdView)
        
        interstitialAd.presentInView(interstitialAdView)
        UIViewController.prepareInterstitialAds()
    }
    
    func interstitialAdActionDidFinish(interstitialAd: ADInterstitialAd!) {
        interstitialAdView.removeFromSuperview()
        newGame()
    }
    
    func interstitialAdActionShouldBegin(interstitialAd: ADInterstitialAd!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!) {
        
    }
    
    func interstitialAdDidUnload(interstitialAd: ADInterstitialAd!) {
        interstitialAdView.removeFromSuperview()
    }

    func roundUp(value: Int, divisor: Int) -> Int {
        let rem = value % divisor
        return rem == 0 ? value : value + divisor - rem
    }

}
