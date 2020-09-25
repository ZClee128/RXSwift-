//
//  PeopleViewController.swift
//  studyRxswift
//
//  Created by zclee on 2019/2/28.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PeopleViewController: UIViewController {
    
    @IBOutlet weak var mytable: UITableView!
    
    let peopleList = PeopleListModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mytable.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        
        peopleList.data
            .bind(to: mytable.rx.items(cellIdentifier: "myCell")) { _,model,cell in
                cell.textLabel?.text = model.name
                cell.detailTextLabel?.text = String(model.age)
            }.disposed(by: disposeBag)
        
        mytable.rx.modelSelected(People.self).subscribe(onNext: { people in
            print("选择了\(people)")
        }).disposed(by: disposeBag)
        
        mytable.rx.itemSelected.subscribe(onNext: { indexPatn in
            print("选择了\(indexPatn.row)行")
        }).disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    
    deinit {
        print(self,"dead")
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
