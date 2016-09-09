//
//  AnimationHelper.swift
//  GitHubUsers
//
//  Created by Brain Agency on 09.09.16.
//  Copyright © 2016 Ivan Balychev. All rights reserved.
//
import UIKit
import Foundation

class AnimationLoader {

    private let loader:SBAnimatedLoaderView
    private let background:UIView!

    static let shared = AnimationLoader()

    init() {

        let frame = CGRectMake(0, 0, 150, 180)
        let backgroundColor = UIColor(red: 22.0/255.0, green: 158.0/255.0, blue: 224.0/225.0, alpha: 1.0)
        let spriteName = "loader_"
        let numberOfSprites = 17
        let animationDuration = 1.25
        let labelText = "Loading..."

        self.background = UIView(frame: UIScreen.mainScreen().bounds)

        self.loader = SBAnimatedLoaderView(frame: frame, color: backgroundColor, spriteName: spriteName, numberOfSprites: numberOfSprites, animationDuration: animationDuration, labelString: labelText, labelTextColor: backgroundColor)

        self.loader.center = self.background.center
        self.background.addSubview(self.loader)
        UIApplication.sharedApplication().keyWindow?.addSubview(self.background)
        self.background.hidden = true

    }

    func show() {
        self.background.hidden = false
        self.loader.show()

    }

    func hide() {
        self.background.hidden = true
        self.loader.hide()
    }

}