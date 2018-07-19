//  File name   : TableViewVM.swift
//
//  Author      : Phuc Tran
//  Created date: 7/14/18
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2018 Aversafe. All rights reserved.
//  --------------------------------------------------------------

import UIKit
import Foundation

#if canImport(RxSwift) && canImport(RxCocoa) && canImport(FwiCore) && canImport(FwiCoreRX)
/// Optional
import FwiCore
import FwiCoreRX

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif


open class TableViewVM: FwiViewModel {

    // MARK: Class's properties
    public var isEnableEditing = false
    public var isEnableSelecting = false
    public fileprivate(set) weak var tableView: UITableView?

    // MARK: Class's constructors
    public init(with tableView: UITableView?) {
        super.init()
        self.tableView = tableView
    }
    
    // MARK: Class's public methods
    open override func setupRX() {
        tableView?.rx
            .setDataSource(self)
            .disposed(by: disposeBag)
        
        tableView?.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }

    open func toggleEdit() {
        guard let isEditing = tableView?.isEditing else {
            return
        }

        if isEditing {
            tableView?.setEditing(false, animated: true)
        } else {
            tableView?.setEditing(true, animated: true)
        }
    }
}

// MARK: UITableViewDataSource's members
extension TableViewVM: UITableViewDataSource {
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fatalError("Child class should override func \(#function)")
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("Child class should override func \(#function)")
    }

    /// Editing.
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (isEnableEditing || isEnableSelecting)
    }
    
    /// Moving/reordering
    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Index.
    open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return nil
    }
    open func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return 0
    }
    
    /// Data manipulation - insert and delete support.
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    /// Data manipulation - reorder / moving support.
    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    }
}

// MARK: UITableViewDelegate's members
extension TableViewVM: UITableViewDelegate {
    
    /// Display customization.
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    }
    open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
    }
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
    }
    open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
    }
    
    /// Variable height support.
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    /// Section header & footer information. Views are preferred over title should you decide to provide both.
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    open func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    }
    
    /// Selection.
    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    open func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
    }
    open func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
    }

    open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    open func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
    
    /// Editing.
    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let option = (isEnableEditing, isEnableSelecting)
        switch option {
        case (false, true):
            return UITableViewCellEditingStyle(rawValue: 3) ?? .none

        case (true, false):
            return .delete

        default:
            return .none
        }
    }
    open func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
    }
    open func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
    }
    
    /// Copy/Paste. All three methods must be implemented by the delegate.
    open func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    open func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }
    open func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
    }
}
#endif
