//
//  ViewController.swift
//  TestApp
//
//  Created by Dung Vu on 3/21/19.
//  Copyright © 2019 Fiision Studio. All rights reserved.
//

import UIKit
import FwiCore
import FwiCoreRX
import RxSwift
//import SnapKit

class ViewController: UIViewController {
//    private var presenter: GenericReuseVM<UITableView, Int>?
//    private lazy var tableView: UITableView = {
//       let table = UITableView(frame: .zero, style: .grouped)
//        table.rowHeight = UITableView.automaticDimension
//        table >>> self.view >>> {
//            $0.snp.makeConstraints({ (make) in
//                make.edges.equalToSuperview()
//            })
//        }
//
//       return table
//    }()

    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // Do any additional setup after loading the view, typically from a nib.
//        let source = Observable.just([5, 6, 7, 8])
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//
//        presenter = GenericReuseVM<UITableView, Int>(self.tableView, use: source, { (tableView, index, item) -> UITableViewCell in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
//            cell?.textLabel?.text = "Value :\(item)"
//            return cell!
//        })
//
//        presenter?.selectedAtIndex.bind(onNext: { (index) in
//            print("\(index.row)")
//        }).disposed(by: disposeBag)
//        
//        presenter?.selectedItem.bind(onNext: { (value) in
//            print("Value: \(value ?? -1)")
//        }).disposed(by: disposeBag)
        
        // Test deinit
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            self.presenter = nil
//        }
        
    }
}
// Override example
//class abc: GenericReuseVM<UITableView, Int> {
//    override init(_ view: UITableView, use source: Observable<[Int]>, _ block: @escaping abc.GenericCell) {
//        super.init(view, use: source, block)
//    }
//}

