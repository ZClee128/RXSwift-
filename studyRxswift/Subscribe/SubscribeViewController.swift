//
//  SubscribeViewController.swift
//  studyRxswift
//
//  Created by zclee on 2019/3/1.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SubscribeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
//      1
        
        let ob = Observable.of(1,2,3)
        ob.subscribe { event in
            print(event.element)
        }
        
//        2 可以通过不同的block回调处理不同类型的event事件 event里的参数打印出来
        ob.subscribe(onNext: { event in
            print(event)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("completed")
        }, onDisposed: {
            print("Disposed")
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
