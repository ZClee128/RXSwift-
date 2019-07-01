//
//  ObservableUtilityOperatorsViewController.swift
//  studyRxswift
//
//  Created by lee on 2019/7/1.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class ObservableUtilityOperatorsViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.delay()
        self.delaySubscription()
        self.materialize()
        self.dematerialize()
        self.timeout()
        self.using()
    }
    
    func delay() {
//        该操作符会将 Observable 的所有元素都先拖延一段设定好的时间，然后才将它们发送出来
        Observable.of(1, 2, 1)
            .delay(3, scheduler: MainScheduler.instance) //元素延迟3秒才发出
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }

    func delaySubscription() {
//        使用该操作符可以进行延时订阅。即经过所设定的时间后，才对 Observable 进行订阅操作。
        Observable.of(1, 2, 1)
            .delaySubscription(3, scheduler: MainScheduler.instance) //延迟3秒才开始订阅
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    func materialize() {
//        该操作符可以将序列产生的事件，转换成元素。
//        通常一个有限的 Observable 将产生零个或者多个 onNext 事件，最后产生一个 onCompleted 或者onError事件。而 materialize 操作符会将 Observable 产生的这些事件全部转换成元素，然后发送出来。
        Observable.of(1, 2, 1)
            .materialize()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    func dematerialize() {
//        该操作符的作用和 materialize 正好相反，它可以将 materialize 转换后的元素还原。
        Observable.of(1, 2, 1)
            .materialize()
            .dematerialize()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    func timeout() {
//        使用该操作符可以设置一个超时时间。如果源 Observable 在规定时间内没有发任何出元素，就产生一个超时的 error 事件
        //定义好每个事件里的值以及发送的时间
        let times = [
            [ "value": 1, "time": 0 ],
            [ "value": 2, "time": 0.5 ],
            [ "value": 3, "time": 1.5 ],
            [ "value": 4, "time": 4 ],
            [ "value": 5, "time": 5 ]
        ]
        
        //生成对应的 Observable 序列并订阅
        Observable.from(times)
            .flatMap { item in
                return Observable.of(Int(item["value"]!))
                    .delaySubscription(Double(item["time"]!),
                                       scheduler: MainScheduler.instance)
            }
            .timeout(2, scheduler: MainScheduler.instance) //超过两秒没发出元素，则产生error事件
            .subscribe(onNext: { element in
                print(element)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func using() {
//        使用 using 操作符创建 Observable 时，同时会创建一个可被清除的资源，一旦 Observable终止了，那么这个资源就会被清除掉了。
        //一个无限序列（每隔0.1秒创建一个序列数 ）
        let infiniteInterval$ = Observable<Int>
            .interval(0.1, scheduler: MainScheduler.instance)
            .do(
                onNext: { print("infinite$: \($0)") },
                onSubscribe: { print("开始订阅 infinite$")},
                onDispose: { print("销毁 infinite$")}
        )
        
        //一个有限序列（每隔0.5秒创建一个序列数，共创建三个 ）
        let limited$ = Observable<Int>
            .interval(0.5, scheduler: MainScheduler.instance)
            .take(2)
            .do(
                onNext: { print("limited$: \($0)") },
                onSubscribe: { print("开始订阅 limited$")},
                onDispose: { print("销毁 limited$")}
        )
        
        //使用using操作符创建序列
        let o: Observable<Int> = Observable.using({ () -> AnyDisposable in
            return AnyDisposable(infiniteInterval$.subscribe())
        }, observableFactory: { _ in return limited$ }
        )
        o.subscribe()
    }
}

class AnyDisposable: Disposable {
    let _dispose: () -> Void
    
    init(_ disposable: Disposable) {
        _dispose = disposable.dispose
    }
    
    func dispose() {
        _dispose()
    }
}
