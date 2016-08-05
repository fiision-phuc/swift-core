//  Project name: FwiCore
//  File name   : UITableViewController+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 8/4/16
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2016 Fiision Studio. All rights reserved.
//  --------------------------------------------------------------

import UIKit
import Foundation


public extension UITabBarController {

    // MARK: Class's override methods
    public override func prefersStatusBarHidden() -> Bool {
        return selectedViewController?.prefersStatusBarHidden() ?? super.prefersStatusBarHidden()
    }
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return selectedViewController?.preferredStatusBarStyle() ?? super.preferredStatusBarStyle()
    }

    public override func shouldAutorotate() -> Bool {
        return selectedViewController?.shouldAutorotate() ?? super.shouldAutorotate()
    }
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return selectedViewController?.supportedInterfaceOrientations() ?? super.supportedInterfaceOrientations()
    }
}
