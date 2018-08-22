//  File name   : FwiCell.swift
//
//  Author      : Dung Vu
//  Created date: 8/10/16
//  --------------------------------------------------------------
//  Copyright © 2012, 2018 Fiision Studio. All Rights Reserved.
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

#if canImport(UIKit)
    import UIKit

    /// FwiCell defines instruction on how to load a cell.
    public protocol FwiCell {
        /// Return cell's identifier.
        static var identifier: String { get }
    }

    /// Default implementation for FwiCell.
    public extension FwiCell {
        static var identifier: String {
            return "\(self)"
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    /// Default added FwiCell to UICollection view cell.
    extension UICollectionViewCell: FwiCell {
    }

    /// FwiCell has addon function only when self is UICollectionViewCell.
    public extension FwiCell where Self: UICollectionViewCell {
        /// Dequeue and cast to self.
        ///
        /// - parameter collectionView (required): collectionView instance
        /// - parameter indexPath (required): indexPath
        public static func dequeueCell(collectionView c: UICollectionView, indexPath i: IndexPath) -> Self {
            return c.dequeueReusableCell(withReuseIdentifier: identifier, for: i) as! Self
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    /// Default added FwiCell to UITableView view cell.
    extension UITableViewCell: FwiCell {
    }

    /// FwiCell has addon function only when self is UITableViewCell.
    public extension FwiCell where Self: UITableViewCell {
        /// Dequeue and cast to self.
        ///
        /// - parameter tableView (required): tableView instance
        public static func dequeueCell(tableView t: UITableView) -> Self {
            return t.dequeueReusableCell(withIdentifier: identifier) as! Self
        }
    }
#endif
