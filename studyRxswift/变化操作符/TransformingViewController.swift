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
        self.view.backgroundColor = .white;
        // Do any additional setup after loading the view.
        
//        self.testBuffer()
//        self.testwindow()
//        self.testMap()
        self.testFlatMap()
//        self.testFlatMapLatest()
//        self.testConcatMap()
//        self.testScan()
//        self.testGroupBy()
    }
    
    func testBuffer() {
        //        buffer
        //        缓冲组合
        
        let subject = PublishSubject<String>()
        //        1秒会缓冲3个一起以数组方式抛出。如果缓存不足3个，也会发出。
        subject
            .buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
//        .debug("buffer:")
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")

        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
    }
    
    func testwindow() {
        //        window 操作符和 buffer 十分相似。不过 buffer 是周期性的将缓存的元素集合发送出来，而 window 周期性的将元素集合以 Observable 的形态发送出来。
        //        同时 buffer要等到元素搜集完毕后，才会发出元素序列。而 window 可以实时发出元素序列。
        let subject = PublishSubject<String>()
        
        //每3个元素作为一个子Observable发出。
        subject
            .window(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self]  in
                print("subscribe: \($0)")
                $0.asObservable()
                    .subscribe(onNext: { print($0) })
                    .disposed(by: self!.disposeBag)
            })
            .disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
//        print("Resources.total ", RxSwift.Resources.total)
        
        subject.onNext("1")
//        print("Resources.total ", RxSwift.Resources.total)
        subject.onNext("2")
        subject.onNext("3")
//        print("Resources.total ", RxSwift.Resources.total)
    }

    func testMap() {
//        该操作符通过传入一个函数闭包把原来的 Observable 序列转变为一个新的 Observable 序列。
//        相当于返回一个10倍的新序列
        Observable.of(1, 2, 3)
            .map { $0 * 10}
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    func testFlatMap() {
//        map 在做转换的时候容易出现“升维”的情况。即转变之后，从一个序列变成了一个序列的序列。
//        而 flatMap 操作符会对源 Observable 的每一个元素应用一个转换方法，将他们转换成 Observables。 然后将这些 Observables 的元素合并之后再发送出来。即又将其 "拍扁"（降维）成一个 Observable 序列。
//        这个操作符是非常有用的。比如当 Observable 的元素本生拥有其他的 Observable 时，我们可以将所有子 Observables 的元素发送出来。
//        相当于合并了两个
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        //Variable is a wrapper for `BehaviorSubject`.
        let variable = Variable(subject1)
        
        variable.asObservable()
            .flatMap { $0 }
//            .map { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("B")
        subject1.onNext("C")

        variable.value = subject2//效果：log:1

        subject1.onNext("D")
        subject1.onNext("E")
        
        //加了后，log出E,3,4
        variable.value = subject1
        subject2.onNext("3")
        subject2.onNext("4")
        
        //再加了后，log出E。居然还能log3，4，有点难理解
          variable.value = subject1
          subject2.onNext("3")
          subject2.onNext("4")
    }
    
    func testFlatMapLatest() {
//        flatMapLatest与flatMap 的唯一区别是：flatMapLatest只会接收最新的value 事件。
//        这样最终就只会输出subject2，subject1就不会输出了
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        
        variable.asObservable()
            .flatMapLatest { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
    }
    
    func testConcatMap() {
//        concatMap 与 flatMap 的唯一区别是：当前一个 Observable 元素发送完毕后，后一个Observable 才可以开始发出元素。或者说等待前一个 Observable 产生完成事件后，才对后一个 Observable 进行订阅。
//        如果subject1不发送onCompleted，subject2永远不会输出
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        
        variable.asObservable()
            .concatMap { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
        subject1.onCompleted() //只有前一个序列结束后，才能接收下一个序列
    }
    
    func testScan() {
//        scan 就是先给一个初始化的数，然后不断的拿前一个结果和最新的值进行处理操作
//        输出为1，3，6，10，15
//        acum 为新值  elem为下一个值
        Observable.of(1, 2, 3, 4, 5)
            .scan(0) { acum, elem in
                acum + elem
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
    }
    
    func testGroupBy()  {
        //        groupBy 操作符将源 Observable 分解为多个子 Observable，然后将这些子 Observable 发送出来。
        //        也就是说该操作符会将元素通过某个键进行分组，然后将分组后的元素序列以 Observable 的形态发送出来。
        //将奇数偶数分成两组
        Observable<Int>.of(0, 1, 2, 3, 4, 5)
            .groupBy(keySelector: { (element) -> String in
                return element % 2 == 0 ? "偶数" : "基数"
            })
            .subscribe { (event) in
                switch event {
                case .next(let group):
                    group.asObservable().subscribe({ (event) in
                        print("key：\(group.key)    event：\(event)")
                    }).disposed(by: self.disposeBag)
                default:
                    print("")
                }
            }
            .disposed(by: disposeBag)
    }
}
