//
//  ObservableViewController.swift
//  studyRxswift
//
//  Created by zclee on 2019/2/28.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum myError: Error {
    case errorA
    case errorB
}

class ObservableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        1.just()  需要一个初始值
        let observable = Observable<String>.just("5")
//        2. of() 这个方法可以接受可变数量的参数 （一定是要同类型）
        let observable2 = Observable.of("a","b","c")
//        3. from() 这个方法需要一个数组
        let observable3 = Observable.from(["a","b","c"])
//        4. empty() 是一个空内容的序列
        let observable4 = Observable<Int>.empty()
//        5. never() 是永远不会发出event，也不会终止
        let observable5 = Observable<Int>.never()
//        6. error()
        let observable6 = Observable<Int>.error(myError.errorA)
//        7. range() 创建一个范围的序列
        let observable7 = Observable.range(start: 1, count: 5)
//        let observable2 = Observable.of(1,2,3,4,5)
        
//        8. repeatElement() 无限发出给定元素的event （永不终止）
        let observable8 = Observable.repeatElement(1)
        
//        9. generate() 判断条件都为true，才会执行序列
        let observable9 = Observable.generate(initialState: 0, condition: { $0 <= 10 }, iterate: { $0 + 2 })
//        (0,2,4,6,8,10)

//        10. create() 这个方法接受一个block形式的参数
        
        let observable10 = Observable<String>.create { ob in
            ob.onNext("zclee is good")
            ob.onCompleted()
//            因为一个订阅行为会有一个Disposables类型的返回值，所以在结尾一定要return一个Disposables
            return Disposables.create {}
        }
        
        
//        11. deferred()  创建一个工厂，
        var isOdd = true
        
        let factory: Observable<Int> = Observable.deferred {
            isOdd = !isOdd
            
            if isOdd {
                return Observable.of(1,3,5,7)
            }
            else {
                return Observable.of(2,4,6,8)
            }
        }
        
//        第一次订阅
        factory.subscribe{ event in
                print("\(isOdd)",event)
        }
        
//        第二次订阅
        factory.subscribe{ event in
            print("\(isOdd)",event)
        }
        
//        12. interval()
        
        let ob = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        
        ob.subscribe { event in
                print(event)
        }
        
//        13. timer()  创建一个经过设定的一段时间后，产生唯一的元素
        let ob2 = Observable<Int>.timer(5, scheduler: MainScheduler.instance)
        
        ob2.subscribe{  event in
                print("ob2--->",event)
        }
        
//        第二种 就是经过设定一段时间，每隔一段时间产生一个元素
//        第一个参数就是等待5秒，第二个参数为每个1秒产生一个元素
        
        let ob3 = Observable<Int>.timer(5, period: 1, scheduler: MainScheduler.instance)
    }


}
