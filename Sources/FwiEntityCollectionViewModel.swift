//  Project name: FwiCore
//  File name   : FwiEntityCollectionViewModel.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 9/4/16
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

#if os(iOS)
import UIKit
import Foundation
import CoreData


public final class FwiEntityCollectionViewModel<T: NSFetchRequestResult> : FwiEntityViewModel<T>, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public typealias CellFactory = (UICollectionView, IndexPath, T) -> UICollectionViewCell
    public typealias SizeFactory = (UICollectionView, IndexPath) -> CGSize
    
    // MARK: Class's constructors
    public convenience init(collectionView c: UICollectionView?, context ctx: NSManagedObjectContext?) {
        self.init(ctx)
        collectionView = c
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    
    // MARK: Class's properties
    public var cellFactory: CellFactory?
    public var sizeFactory: SizeFactory?
    
    public lazy var minLineSpacing = 0.0
    public lazy var minInteritemSpacing = 0.0
    public lazy var sectionInset = UIEdgeInsets.zero
    
    fileprivate weak var collectionView: UICollectionView?
    
    // MARK: Class's private methods
    internal override func performFetch() {
        super.performFetch()
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.reloadData()
        }
    }
    
    // MARK: UICollectionViewDataSource's members
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionCount()
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount(forSection: section)
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellFactory = cellFactory, let item = item(forIndexPath: indexPath) else {
            return UICollectionViewCell()
        }
        return cellFactory(collectionView, indexPath, item)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout's members
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let sizeFactory = sizeFactory else {
            return CGSize.zero
        }
        return sizeFactory(collectionView, indexPath)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(minLineSpacing)
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(minInteritemSpacing)
    }
    
    // MARK: NSFetchedResultsControllerDelegate's members
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.performBatchUpdates(
                {
                    if let array = self?.deleteArrays {
                        self?.collectionView?.deleteItems(at: array)
                    }
                    if let array = self?.insertArrays {
                        self?.collectionView?.insertItems(at: array)
                    }
                    if let array = self?.deleteArrays {
                        self?.collectionView?.reloadItems(at: array)
                    }
                },
                completion: { _ in
                    self?.deleteArrays = nil
                    self?.insertArrays = nil
                    self?.reloadArrays = nil
                }
            )
        }
    }
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        DispatchQueue.main.async { [weak self] in
            switch type {
            case .insert:
                self?.collectionView?.insertSections(IndexSet(integer: sectionIndex))
                break
                
            case .delete:
                self?.collectionView?.deleteSections(IndexSet(integer: sectionIndex))
                break
                
            default:
                break
            }
        }
    }
}
#endif
