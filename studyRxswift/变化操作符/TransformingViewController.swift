//
//  TransformingViewController.swift
//  studyRxswift
//
//  Created by zclee on 2019/6/17.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class TransformingViewController: UIViewController {

    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        buffer
//        缓冲组合
        
        let subject = PublishSubject<String>()
//        1秒会缓冲3个一起抛出 
        subject
            .buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { print($0)})
            .disposed(by: disposeBag)
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
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
