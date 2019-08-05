//
//  TableView2Controller.swift
//  studyRxswift
//
//  Created by lee on 2019/8/5.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

//注意：RxDataSources 是以 section 来做为数据结构的。所以不管我们的 tableView 是单分区还是多分区，在使用 RxDataSources 的过程中，都需要返回一个 section 的数组。
class TableView2Controller: BaseViewController {
    
    var myTable: UITableView!
    
    var startBtn: UIBarButtonItem!
    var cancleBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myTable = UITableView(frame: CGRect(x: 0, y: 88, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-88), style: .plain)
        self.view.addSubview(self.myTable)
        self.myTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.startBtn = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: nil)
//        self.startBtn.title = "刷新"
        self.cancleBtn = UIBarButtonItem.init(title: "停止", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItems = [self.startBtn, self.cancleBtn]
        
        let results = self.startBtn.rx.tap.asObservable()
            .throttle(1, scheduler: MainScheduler.instance) //在主线程中操作，1秒内值若多次改变，取最后一次
            .startWith(()) //加这个为了让一开始就能自动请求一次数据
            .flatMapLatest{
                self.getRandomResult().takeUntil(self.cancleBtn.rx.tap) //停止
            } //flatMapLatest 的作用是当在短时间内（上一个请求还没回来）连续点击多次“刷新”按钮，虽然仍会发起多次请求，但表格只会接收并显示最后一次请求。避免表格出现连续刷新的现象。
            .share().retry(1)
        
        //        初始化数据
        let items = Observable.just([
            SectionModel(model: "第一组", items: [
                "a",
                "b",
                "c"
                ]),
            SectionModel(model: "第二组", items: [
                "e",
                "f",
                "g"
                ])
            ])
        
        //        第一种写法，用系统的section
        //创建数据源
        //        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,String>>(configureCell: {dataSource,tableview,IndexPath,element in
        //            let cell = tableview.dequeueReusableCell(withIdentifier: "cell")
        //            cell?.textLabel?.text = "\(IndexPath.row):\(element)"
        //            return cell!
        //        })
        //
        ////        多分区的 UITableView
        //        dataSource.titleForHeaderInSection = { dataSource,IndexPath in
        //                return dataSource.sectionModels[IndexPath].model
        //        }
        //
        //
        //        items.bind(to: self.myTable.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        //        第二种写法 自定义 section
//        let items2 = Observable.just([
//            MySection(header: "第一组", items: [
//                "a",
//                "b",
//                "c"
//                ]),
//            MySection(header: "第二组", items: [
//                "e",
//                "f",
//                "g"
//                ])
//            ])
//        let dataSource = RxTableViewSectionedReloadDataSource<MySection>(configureCell: { dataSoure, tableview, IndexPath, element in
//            let cell = tableview.dequeueReusableCell(withIdentifier: "cell")
//            cell?.textLabel?.text = "\(IndexPath.row):\(element)"
//            return cell!
//        },titleForHeaderInSection: { dataSource , IndexPath in
//            //         多分区的 UITableView
//            return dataSource.sectionModels[IndexPath].header
//        })
//
//
//
//        items2.bind(to: self.myTable.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource
            <SectionModel<String, Int>>(configureCell: {
                (dataSource, tableview, indexPath, element) in
                let cell = tableview.dequeueReusableCell(withIdentifier: "cell")!
                cell.textLabel?.text = "条目\(indexPath.row)：\(element)"
                return cell
            })
        results.bind(to: self.myTable.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    //获取随机数据
    func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
        print("正在请求数据......")
        let items = (0 ..< 5).map {_ in
            Int(arc4random())
        }
        let observable = Observable.just([SectionModel(model: "S", items: items)])
        return observable.delay(2, scheduler: MainScheduler.instance)
    }
}


// 自定义section
struct MySection {
    var header: String
    var items: [Item]
    
}

extension MySection : AnimatableSectionModelType {
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: MySection, items: [MySection.Item]) {
        self = original
        self.items = items
    }
}
