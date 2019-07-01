//
//  DebugViewController.swift
//  studyRxswift
//
//  Created by lee on 2019/7/1.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DebugViewController: UIViewController {

    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.debug()
        self.ResourcesTotal()
    }
    
    func debug() {
//        我们可以将 debug 调试操作符添加到一个链式步骤当中，这样系统就能将所有的订阅者、事件、和处理等详细信息打印出来，方便我们开发调试。
//        debug() 方法还可以传入标记参数，这样当项目中存在多个 debug 时可以很方便地区分出来。
        Observable.of("2", "3")
            .startWith("1")
            .debug("调试")
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }

    func ResourcesTotal() {
//        RxSwift.Resources.total
//        通过将 RxSwift.Resources.total 打印出来，我们可以查看当前 RxSwift 申请的所有资源数量。这个在检查内存泄露的时候非常有用。
        print(RxSwift.Resources.total)
        
        Observable.of("BBB", "CCC")
            .startWith("AAA")
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        print(RxSwift.Resources.total)
    }
}
