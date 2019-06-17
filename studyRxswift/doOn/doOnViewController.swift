//
//  doOnViewController.swift
//  studyRxswift
//
//  Created by zclee on 2019/3/1.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class doOnViewController: UIViewController {
    
    //    doOn 是用来监听事件的生命周期，它会在每一次事件发送前被调用
    //    doOn 和 subscribe 是一样的
    //    do(onNext:) 会在 subscribe(onNext:) 前调用
    //    do(onCompleted:) 会在 subscribe(onCompleted:) 前面调用
    override func viewDidLoad() {
        super.viewDidLoad()
        let ob = Observable.of(1,2,3)
        
        ob.do(onNext: { element in
            print("do-->",element)
        }, onError: { error in
            print("do-->",error)
        }, onCompleted: {
            print("do ---> completed")
        }, onDispose: {
            print("do --->Disposed")
        })
            .subscribe(onNext: { event in
                print("subscribe",event)
            }, onError: { error in
                print("subscribe",error)
            }, onCompleted: {
                print("subscribe completed")
            }, onDisposed: {
                print("subscribe Disposed")
            })
        
        
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
