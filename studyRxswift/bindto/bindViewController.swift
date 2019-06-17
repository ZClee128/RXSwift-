//
//  bindViewController.swift
//  studyRxswift
//
//  Created by zclee on 2019/3/1.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class bindViewController: UIViewController {

    @IBOutlet weak var mylable: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        观察者
        let observer: AnyObserver<String> = AnyObserver { [weak self] event in
            switch event {
            case .next(let text):
                self?.mylable.text = text
            default:
                break
            }
        }
        
        
//        Binder 用于特定场景
//        1、不会处理错误事件
//        2、确保绑定都是在给定的 Scheduler 上执行 默认MainScheduler.instance
        
//        let binderServer: Binder<String> = Binder(mylable) { (lab, text) in
//            lab.text = text
//        }
        
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        
        observable
            .map { "当前索引：\($0)" }
            .bind(to: mylable.rx.text)
            .disposed(by: disposeBag)
        
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
