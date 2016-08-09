//
//  ColorGameButton.swift
//  ColorGame
//
//  Created by Keegan on 1/19/16.
//  Copyright © 2016 Keegan Rush. All rights reserved.
//

import UIKit
import QuartzCore

class ColorGameButton: UIButton {
    private var _backgroundLayer: CAGradientLayer?
    private var _buttonColor: UIColor!
    @IBInspectable var buttonXInset: CGFloat
        {
        didSet
            {
            contentEdgeInsets = UIEdgeInsetsMake(buttonYInset, buttonXInset, buttonYInset, buttonXInset)
            }
        }
    
    @IBInspectable var buttonYInset: CGFloat
        {
        didSet
            {
            contentEdgeInsets = UIEdgeInsetsMake(buttonYInset, buttonXInset, buttonYInset, buttonXInset)
            }
    }
    
    @IBInspectable var buttonColor: UIColor
        {
        didSet
            {
            setColorForButton(buttonColor)
            }
        }
    
    required init?(coder aDecoder: NSCoder) {
        buttonXInset = 5
        buttonYInset = 5
        buttonColor = Utilities.appColor()
        super.init(coder: aDecoder)
        let theLayer = self.layer
        theLayer.cornerRadius = 4.5
        theLayer.borderWidth = 1
        setColorForButton(Utilities.appColor())
        contentEdgeInsets = UIEdgeInsetsMake(buttonYInset, buttonXInset, buttonYInset, buttonXInset)
        drawBackgroundLayer()
    }
    
    func setColorForButton(color: UIColor)
        {
        _buttonColor = color
        layer.borderColor = _buttonColor.CGColor
        layer.backgroundColor = _buttonColor.CGColor
        }
    
    func drawBackgroundLayer()
        {
        guard _backgroundLayer == nil else
            {
            return
            }
        _backgroundLayer = CAGradientLayer()

        _backgroundLayer!.colors = [UIColor.redColor(), UIColor.blueColor()]
        _backgroundLayer!.locations = [0.0, 1.0]

        self.layer.insertSublayer(_backgroundLayer!, atIndex: 0)
    }
}
