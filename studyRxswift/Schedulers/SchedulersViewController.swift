//
//  SchedulersViewController.swift
//  studyRxswift
//
//  Created by lee on 2019/7/4.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class SchedulersViewController: UIViewController {

    /**
         （1）调度器（Schedulers）是 RxSwift 实现多线程的核心模块，它主要用于控制任务在哪个线程或队列运行。
         （2）RxSwift 内置了如下几种 Scheduler：
     
     
         CurrentThreadScheduler：表示当前线程 Scheduler。（默认使用这个）
     
         MainScheduler：表示主线程。如果我们需要执行一些和 UI 相关的任务，就需要切换到该 Scheduler运行。
     
         SerialDispatchQueueScheduler：封装了 GCD 的串行队列。如果我们需要执行一些串行任务，可以切换到这个 Scheduler 运行。
     
         ConcurrentDispatchQueueScheduler：封装了 GCD 的并行队列。如果我们需要执行一些并发任务，可以切换到这个 Scheduler 运行。
     
         OperationQueueScheduler：封装了 NSOperationQueue。
     */
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
//        以前GCD的写法
        //现在后台获取数据
        DispatchQueue.global(qos: .userInitiated).async {
            getPlaylist("0")
                .subscribe(onSuccess: { (json) in
                    //再到主线程显示结果
                    DispatchQueue.main.async {
//                        self.data = json[...]
                    }
                }, onError: { (error) in
                    
                })
        }
        
//        RxSwift的写法
        getPlaylist("0")
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated)) ////后台构建序列
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { (json) in
                //                        self.data = json[...]
            }) { (error) in
                
        }.disposed(by: disposeBag)
    }
    /**
        这个模块我只能用伪代码来展示一下用法，因为这个只是一个基础教程，后面我会在项目中讲解
        现在讲讲区别
         （1）subscribeOn()
     
         该方法决定数据序列的构建函数在哪个 Scheduler 上运行。
         比如上面样例，由于获取数据、解析数据需要花费一段时间的时间，所以通过 subscribeOn 将其切换到后台 Scheduler 来执行。这样可以避免主线程被阻塞。
     
         （2）observeOn()
     
         该方法决定在哪个 Scheduler 上监听这个数据序列。
         比如上面样例，我们获取并解析完毕数据后又通过 observeOn 方法切换到主线程来监听并且处理结果。
     */

}
