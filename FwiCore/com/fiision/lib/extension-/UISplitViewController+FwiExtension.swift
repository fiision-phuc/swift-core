//  Project name: BrandedApp
//  File name   : UISplitViewController+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 8/4/16
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2016 Zinio LLC. All rights reserved.
//  --------------------------------------------------------------

import UIKit
import Foundation


public extension UISplitViewController {

    // MARK: Class's override methods
    public override func prefersStatusBarHidden() -> Bool {
        if UIApplication.isPhone() {
            return viewControllers.first?.prefersStatusBarHidden() ?? super.prefersStatusBarHidden()
        }
        return super.prefersStatusBarHidden()
    }
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if UIApplication.isPhone() {
            return viewControllers.first?.preferredStatusBarStyle() ?? super.preferredStatusBarStyle()
        }
        return super.preferredStatusBarStyle()
    }

    public override func shouldAutorotate() -> Bool {
        if UIApplication.isPhone() {
            return viewControllers.first?.shouldAutorotate() ?? super.shouldAutorotate()
        }
        return super.shouldAutorotate()
    }
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIApplication.isPhone() {
            return viewControllers.first?.supportedInterfaceOrientations() ?? super.supportedInterfaceOrientations()
        }
        return super.supportedInterfaceOrientations()
    }
}
