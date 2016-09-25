//  Project name: FwiCore
//  File name   : UIViewController+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 9/3/16
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2012, 2016 Fiision Studio.
//  All Rights Reserved.
//  --------------------------------------------------------------
//
//  Permission is hereby granted, free of charge, to any person obtaining  a  copy
//  of this software and associated documentation files (the "Software"), to  deal
//  in the Software without restriction, including without limitation  the  rights
//  to use, copy, modify, merge,  publish,  distribute,  sublicense,  and/or  sell
//  copies of the Software,  and  to  permit  persons  to  whom  the  Software  is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF  ANY  KIND,  EXPRESS  OR
//  IMPLIED, INCLUDING BUT NOT  LIMITED  TO  THE  WARRANTIES  OF  MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO  EVENT  SHALL  THE
//  AUTHORS OR COPYRIGHT HOLDERS  BE  LIABLE  FOR  ANY  CLAIM,  DAMAGES  OR  OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING  FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN  THE
//  SOFTWARE.
//
//
//  Disclaimer
//  __________
//  Although reasonable care has been taken to  ensure  the  correctness  of  this
//  software, this software should never be used in any application without proper
//  testing. Fiision Studio disclaim  all  liability  and  responsibility  to  any
//  person or entity with respect to any loss or damage caused, or alleged  to  be
//  caused, directly or indirectly, by the use of this software.

import UIKit


public extension UIViewController {

    /// Add initial view controller from other storyboard into defined view. Default is view
    /// controller's view.
    @discardableResult
    public func addFlow(fromStoryboard storyboardName: String, intoView rootView: UIView, inBundle bundle: Bundle = Bundle.main) -> UIViewController? {
        let flow = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let controller = flow.instantiateInitialViewController(), let subView = controller.view else {
            return nil
        }
        
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(controller)
        view.addSubview(subView)
        
        let views = ["subView":subView]
        let constraints1 = NSLayoutConstraint.constraints(withVisualFormat: "|[subView]|", options: .alignAllLeading, metrics: nil, views: views)
        let constraints2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|", options: .alignAllLeading, metrics: nil, views: views)
        view.addConstraints(constraints1)
        view.addConstraints(constraints2)
        
        controller.willMove(toParentViewController: self)
        controller.didMove(toParentViewController: self)
        return controller
    }
}
