//
//  UpgradesViewController.swift
//  ColorGame
//
//  Created by Keegan on 1/19/16.
//  Copyright © 2016 Keegan Rush. All rights reserved.
//

import UIKit
import AVKit
import iAd
import StoreKit

class UpgradesViewController: UITableViewController {

    @IBOutlet var headerView: UIView!
    @IBOutlet var footerView: UIView!
    @IBOutlet var pointsLabel: UILabel!
    var moviePlayer: AVPlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSBundle.mainBundle().loadNibNamed("UpgradesHeaderView", owner: self, options: nil)
        NSBundle.mainBundle().loadNibNamed("UpgradesFooterView", owner: self, options: nil)
        tableView.tableHeaderView = headerView
        self.tableView.scrollEnabled = false
        
        let width = tableView.tableHeaderView!.bounds.size.width
        var height = tableView.contentSize.height
        height = height + UIApplication.sharedApplication().statusBarFrame.size.height
        height = height + tableView.tableHeaderView!.bounds.size.height
        
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        tableView.tableFooterView = footerView
        tableView.tableFooterView!.bounds = CGRectMake(0, 0, width, screenHeight - height)
        let frame = tableView.tableFooterView!.frame
        let bounds = tableView.tableFooterView!.bounds
        tableView.tableFooterView!.frame = CGRectMake(frame.origin.x, frame.origin.y, bounds.size.width, bounds.size.height)

        moviePlayer = AVPlayerViewController()
        moviePlayer.showsPlaybackControls = false
    }

    override func viewWillAppear(animated: Bool) {
        pointsLabel.text = "\(AppManager.sharedInstance().currentPoints) points out of 100,000"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
        {
        switch (indexPath.section)
            {
            case 0:
            if InAppPurchasesManager.sharedInstance().purchasesArray?.count > 0
            {
                let identifier = InAppPurchasesManager.sharedInstance().identifierForProductAtIndex(indexPath.row)
                InAppPurchasesManager.sharedInstance().presentPurchaseDialogInViewController(self.navigationController!, forProductIdentifier: identifier)
                }
                break
            case 1:
                if indexPath.row == 0
                    {
                    playAds()
                    }
                break
            default:
                break
            }
        self.tableView.selectRowAtIndexPath(nil, animated: true, scrollPosition: UITableViewScrollPosition.None)
        }
    

    override func awakeFromNib() {
        self.setViewControllerTitle("Color Game")
        self.tableView.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "IAPLoaded:", name: IAPLoadedNotification, object: nil)
        
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "pointsIncreased:", name: PointsIncreasedNotification, object: nil)
    }
    
    func pointsIncreased(notification: NSNotification)
        {
        self.pointsLabel.text = "\(AppManager.sharedInstance().currentPoints) points out of 100,000"
    }
    
    func IAPLoaded(notification: NSNotification)
        {
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
            {
                if InAppPurchasesManager.sharedInstance().purchasesArray?.count > 0
                    {
                        return InAppPurchasesManager.sharedInstance().purchasesArray.count
                }
                else
                    {
                        return 1
                }
        }
        else
            {
                return 1
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
            {
            return "Purchase Upgrades"
        }
        else if section == 1
            {
                return "Get Free Points"
        }
        return nil
    }
    var alert: UIAlertController!
    
    func playAds()
        {
            moviePlayer.modalPresentationStyle = .OverCurrentContext
            presentViewController(self.moviePlayer, animated:true, completion:nil)
            moviePlayer.playPrerollAdWithCompletionHandler({(error: NSError!) in
                if error != nil
                {
                    print(error)
                    self.alert = UIAlertController(title: "Problem loading video ad", message: "The video ad couldn't be loaded right now. Please try again later.", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    self.alert.addAction(action)
                }
                else
                {
                    AppManager.sharedInstance().currentPoints += 50
                    self.alert = UIAlertController(title: "Free Points", message: "You've earned 50 points", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    self.alert.addAction(action)
                }
                self.dismissViewControllerAnimated(true, completion: {
                self.presentViewController(self.alert, animated: true, completion: nil)
                self.alert.view.tintColor = UIView().tintColor})
                self.pointsLabel.text = "\(AppManager.sharedInstance().currentPoints) points out of 100,000"
            })
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //UpgradesTableCell
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UpgradesTableCell")
        if (indexPath.section == 0)
            {
            if InAppPurchasesManager.sharedInstance().purchasesArray?.count > 0
                {
                let product: SKProduct = InAppPurchasesManager.sharedInstance().purchasesArray[indexPath.row] as! SKProduct
                cell!.textLabel!.text = product.localizedTitle
                }
            else
                {
                cell!.textLabel!.text = "No purchases found"
                }
            }
        else
            {
            cell!.textLabel!.text = "Watch a video to earn free points"
            }
        return cell!
    }

}
