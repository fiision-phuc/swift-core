//  Project name: BrandedApp
//  File name   : UINavigationController+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 8/4/16
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2016 Zinio LLC. All rights reserved.
//  --------------------------------------------------------------

import UIKit
import Foundation


public extension UINavigationController {

    // MARK: Class's override methods
    public override func prefersStatusBarHidden() -> Bool {
        return visibleViewController?.prefersStatusBarHidden() ?? super.prefersStatusBarHidden()
    }
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return visibleViewController?.preferredStatusBarStyle() ?? super.preferredStatusBarStyle()
    }

    public override func shouldAutorotate() -> Bool {
        return visibleViewController?.shouldAutorotate() ?? super.shouldAutorotate()
    }
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return visibleViewController?.supportedInterfaceOrientations() ?? super.supportedInterfaceOrientations()
    }
}
