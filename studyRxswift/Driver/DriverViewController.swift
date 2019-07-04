//
//  DriverViewController.swift
//  studyRxswift
//
//  Created by lee on 2019/7/4.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DriverViewController: UIViewController {
    /**
     Driver 可以说是最复杂的 trait，它的目标是提供一种简便的方式在 UI 层编写响应式代码。
     所以单独拿出来讲
     如果我们的序列满足如下特征，就可以使用它：
     
     不会产生 error 事件
     一定在主线程监听（MainScheduler）
     共享状态变化（shareReplayLatestWhileConnected）
     为什么要使用Driver:
     （1）Driver 最常使用的场景应该就是需要用序列来驱动应用程序的情况了，比如：
     
     通过 CoreData 模型驱动 UI
     
     使用一个 UI 元素值（绑定）来驱动另一个 UI 元素值
     
     （2）与普通的操作系统驱动程序一样，如果出现序列错误，应用程序将停止响应用户输入。
     （3）在主线程上观察到这些元素也是极其重要的，因为 UI 元素和应用程序逻辑通常不是线程安全的。
     （4）此外，使用构建 Driver 的可观察的序列，它是共享状态变化。
     */
    let disposeBag = DisposeBag()
    let query:UITextField = UITextField.init(frame: CGRect(x: 100, y: 100, width: 375, height: 50))
    let resultCount:UILabel = UILabel.init(frame: CGRect(x: 100, y: 200, width: 375, height: 50))
    let resultsTableView:UITableView = UITableView.init(frame: CGRect(x: 100, y: 300, width: 300, height: 300))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
        self.view.addSubview(query)
        query.backgroundColor = .red
        resultCount.backgroundColor = .orange
        self.view.addSubview(resultCount)
        self.view.addSubview(resultsTableView)
        resultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        self.testDriver1()
//        self.testDriver2()
//        self.testDriver3()
    }
    /**
        这个是官方提供的样例，大致的意思是根据一个输入框的关键字，来请求数据，然后将获取到的结果绑定到另一个 Label 和 TableView 中。
     */
    func testDriver1() {
        /**
             初学者使用 Observable 序列加 bindTo 绑定来实现这个功能
         */
        let results = query.rx.text
            .throttle(0.3, scheduler: MainScheduler.instance) //在主线程中操作，0.3秒内值若多次改变，取最后一次
            .flatMapLatest { query in //筛选出空值, 拍平序列
                getPlaylist(query ?? "0") //向服务器请求一组结果
        }
//        print("results\(results.singers)")
        //将返回的结果绑定到用于显示结果数量的label上
        results
            .map { "\($0.count)" }
            .bind(to: resultCount.rx.text)
            .disposed(by: disposeBag)

        //将返回的结果绑定到tableView上
        results
            .bind(to: resultsTableView.rx.items(cellIdentifier: "Cell")) { (_, result, cell) in
                cell.textLabel?.text = "\(result)"
            }
            .disposed(by: disposeBag)
    }
    
    func testDriver2() {
        //        但是上面代码会存在三个问题
        
        /**
         如果 getPlaylist 的序列产生了一个错误（网络请求失败），这个错误将取消所有绑定。此后用户再输入一个新的关键字时，是无法发起新的网络请求。
         如果 getPlaylist 在后台返回序列，那么刷新页面也会在后台进行，这样就会出现异常崩溃。
         返回的结果被绑定到两个 UI 元素上。那就意味着，每次用户输入一个新的关键字时，就会分别为两个 UI元素发起 HTTP请求，这并不是我们想要的结果。
         */
        
        //        所以我们要对上面的方法做出修改
        let results = query.rx.text
            .throttle(0.3, scheduler: MainScheduler.instance)//在主线程中操作，0.3秒内值若多次改变，取最后一次
            .flatMapLatest { query in //筛选出空值, 拍平序列
                getPlaylist(query ?? "0")   //向服务器请求一组结果
                    .observeOn(MainScheduler.instance)  //将返回结果切换到到主线程上
                    .catchErrorJustReturn([:])       //错误被处理了，这样至少不会终止整个序列
            }
            .share(replay: 1)                //HTTP 请求是被共享的
        
        //将返回的结果绑定到显示结果数量的label上
        results
            .map { "\($0.count)" }
            .bind(to: resultCount.rx.text)
            .disposed(by: disposeBag)
        
        //将返回的结果绑定到tableView上
        results
            .bind(to: resultsTableView.rx.items(cellIdentifier: "Cell")) { (_, result, cell) in
                cell.textLabel?.text = "\(result)"
            }
            .disposed(by: disposeBag)
    }
    
    func testDriver3() {
        /**
         虽然我们通过增加一些额外的处理，让程序可以正确运行。到对于一个大型的项目来说，如果都这么干也太麻烦了，而且容易遗漏出错。所以这时候我们就要用到Driver
         */
        
        /**
         我们先讲一下代码的思路
         代码讲解：
         （1）首先我们使用 asDriver 方法将 ControlProperty 转换为 Driver。ControlProperty是专门用来描述UI控件属性，拥有该类型的属性都是被观察者（Observable）
         （2）接着我们可以用 .asDriver(onErrorJustReturn: [:]) 方法将任何 Observable 序列都转成 Driver，因为我们知道序列转换为 Driver 要他满足 3 个条件：
         
         *   不会产生 error 事件
         *   一定在主线程监听（MainScheduler）
         *   共享状态变化（shareReplayLatestWhileConnected）
         
         而 asDriver(onErrorJustReturn: [:]) 相当于以下代码：
         let safeSequence = xs
         .observeOn(MainScheduler.instance) // 主线程监听
         .catchErrorJustReturn(onErrorJustReturn) // 无法产生错误
         .share(replay: 1, scope: .whileConnected)// 共享状态变化
         return Driver(raw: safeSequence) // 封装
         （3）同时在 Driver 中，框架已经默认帮我们加上了 shareReplayLatestWhileConnected，所以我们也没必要再加上"replay"相关的语句了。
         （4）最后记得使用 drive 而不是 bindTo
         */
        
        /**
         修改完代码如下
         由于 drive 方法只能被 Driver 调用。这意味着，如果代码存在 drive，那么这个序列不会产生错误事件并且一定在主线程监听。这样我们就可以安全的绑定 UI元素
         */
        let results = query.rx.text.asDriver()        // 将普通序列转换为 Driver
            .throttle(0.3)
            .flatMapLatest { query in
                getPlaylist(query ?? "0")
                    .asDriver(onErrorJustReturn: [:])  // 仅仅提供发生错误时的备选返回值
        }
        
        //将返回的结果绑定到显示结果数量的label上
        results
            .map { "\($0.count)" }
            .drive(resultCount.rx.text) // 这里使用 drive 而不是 bindTo
            .disposed(by: disposeBag)
        
        //将返回的结果绑定到tableView上
        results
            .drive(resultsTableView.rx.items(cellIdentifier: "Cell")) { //  同样使用 drive 而不是 bindTo
                (_, result, cell) in
                cell.textLabel?.text = "\(result)"
            }
            .disposed(by: disposeBag)
    }
}
