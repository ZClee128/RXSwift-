//
//  subjectsViewController.swift
//  studyRxswift
//
//  Created by zclee on 2019/3/2.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class subjectsViewController: UIViewController {
    
    //    subjects 即使订阅者也是observable
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        1. PublishSubject  不需要初值就可以创建
        let subject = PublishSubject<String>()
        
        subject.onNext("0000")
        
        subject.subscribe(onNext: { string in
            print("第一次订阅", string)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("第一次 completed")
        }).disposed(by: disposeBag)
        
        subject.onNext("1111")
        
        subject.subscribe(onNext: { string in
            print("第二次订阅", string)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("第二次 completed")
        }).disposed(by: disposeBag)
        
        subject.onNext("2222")
        
        subject.onCompleted()
        
        subject.onNext("3333")
        
        subject.subscribe(onNext: { string in
            print("第三次订阅",string)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("第三次completed")
        }).disposed(by: disposeBag)
        
        //       2 BehaviorSubject 需要一个默认值来创建
        
        let subject2 = BehaviorSubject(value: 111)
        
        subject2.subscribe { (event) in
            print("BehaviorSubject 第一次订阅",event)
            }.disposed(by: disposeBag)
        
        subject2.onNext(222)
        
        subject2.onError(NSError(domain: "local", code: 0, userInfo: nil))
        
        subject2.subscribe { (event) in
            print("BehaviorSubject 第二次订阅", event)
            }.disposed(by: disposeBag)
        
        
        //       3 ReplaySubject  buffersize
        
        let subject3 = ReplaySubject<String>.create(bufferSize: 2)
        
        //        连续发3个事件
        subject3.onNext("111")
        subject3.onNext("222")
        subject3.onNext("333")
        
        subject3.subscribe { (event) in
            print("第一次订阅", event)
            }.disposed(by: disposeBag)
        
        subject3.onNext("444")
        
        
        subject3.subscribe { (event) in
            print("第二次订阅", event)
            }.disposed(by: disposeBag)
        
        subject3.onCompleted()
        
        subject3.subscribe { (event) in
            print("第三次订阅", event)
            }.disposed(by: disposeBag)
//        4 Variable 它会把当前发出去的值保存为自己的状态 同时它会在销毁时自动发送 .complete 的 event
//        本身没有 subscribe() , 内部是有一个 asObservable()
        
        let subject4 = Variable("111")
        
        subject4.value = "222"
        
        subject4.asObservable().subscribe { (event) in
             print("第一次订阅", event)
        }.disposed(by: disposeBag)
        
        subject4.value = "333"
        
        subject4.asObservable().subscribe { (event) in
            print("第二次订阅", event)
            }.disposed(by: disposeBag)
        subject4.value = "444"
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
