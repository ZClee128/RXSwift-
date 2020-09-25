//
//  ViewController.swift
//  studyRxswift
//
//  Created by zclee on 2019/2/28.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct DataModel {
    let className: UIViewController.Type?
    let name: String?
}

struct DataListModel {
    let data = Observable.just([
        DataModel(className: PeopleViewController.self,name: "tableview"),
        DataModel(className: ObservableViewController.self, name: "Observable"),
        DataModel(className: SubscribeViewController.self, name: "Subscribe"),
        DataModel(className: doOnViewController.self, name: "doOn"),
        DataModel(className: DisposeViewController.self, name: "Dispose"),
        DataModel(className: bindViewController.self, name: "bindto"),
        DataModel(className: exViewController.self, name: "extension"),
        DataModel(className: subjectsViewController.self, name: "subject"),
        DataModel(className: TransformingViewController.self, name: "TransformingViewController"),
        DataModel(className: FilteringObservablesViewController.self, name: "FilteringObservablesViewController"),
        DataModel(className: ConditionalBooleanOperatorsViewController.self, name: "ConditionalBooleanOperatorsViewController"),
        DataModel(className: CombiningObservablesViewController.self, name: "CombiningObservablesViewController"),
        DataModel(className: MathematicalAggregateOperatorsViewController.self, name: "MathematicalAggregateOperatorsViewController"),
        DataModel(className: ConnectableObservableOperatorsViewController.self, name: "ConnectableObservableOperatorsViewController"),
        DataModel(className: ObservableUtilityOperatorsViewController.self, name: "ObservableUtilityOperatorsViewController"),
        DataModel(className: ErrorHandlingOperatorsViewController.self, name: "ErrorHandlingOperatorsViewController"),
        DataModel(className: DebugViewController.self, name: "DebugViewController"),
        DataModel(className: TraitsViewController.self, name: "TraitsViewController"),
        DataModel(className: DriverViewController.self, name: "DriverViewController"),
        DataModel(className: ControlPropertyViewController.self, name: "ControlPropertyViewController"),
        DataModel(className: SchedulersViewController.self, name: "SchedulersViewController"),
        DataModel(className: UIlabelViewController.self, name: "UIlabelViewController"),
        DataModel(className: TextViewController.self, name: "TextViewController"),
        DataModel(className: UIButtonViewController.self, name: "UIButtonViewController"),
        DataModel(className: SwitchViewController.self, name: "SwitchViewController"),
        DataModel(className: UIActivityIndicatorViewController.self, name: "UIActivityIndicatorViewController"),
        DataModel(className: UISliderViewController.self, name: "UISliderViewController"),
        DataModel(className: BidirectionalDataViewController.self, name: "BidirectionalDataViewController"),
        DataModel(className: UIGestureRecognizerViewController.self, name: "UIGestureRecognizerViewController"),
        DataModel(className: UIDatePickerViewController.self, name: "UIDatePickerViewController"),
        DataModel(className: TableViewController.self, name: "TableViewController"),
        DataModel(className: TableView2Controller.self, name: "TableView2Controller"),
        DataModel(className: SeachTableViewController.self, name: "SeachTableViewController")
        ])
}

class ViewController: UIViewController {
    
    @IBOutlet weak var mytable: UITableView!
    
    let disposeBag = DisposeBag()
    
    let dataList = DataListModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        mytable.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        dataList.data
            .bind(to: mytable.rx.items(cellIdentifier:"myCell")) { _, model, cell in
                cell.textLabel?.text = model.name
            }.disposed(by: disposeBag)
        
        mytable.rx.modelSelected(DataModel.self).subscribe({ event in
//            self.present(event.element!.className as! UIViewController, animated: true, completion: {
//            })
           
            let lVCClass = event.element?.className
            if let lVCClass = lVCClass{
                let lVC = lVCClass.init()
                self.navigationController?.pushViewController(lVC, animated: true)
            }
        }).disposed(by: disposeBag)
        
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}

