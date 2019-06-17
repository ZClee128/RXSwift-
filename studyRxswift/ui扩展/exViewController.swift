//
//  exViewController.swift
//  studyRxswift
//
//  Created by zclee on 2019/3/1.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class exViewController: UIViewController {
    
    @IBOutlet weak var mylable: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let observable = Observable<Int>.interval(0.5, scheduler: MainScheduler.instance)
        
        observable
            .map { CGFloat( $0 ) }
            .bind(to: mylable.rx.fontSize)
            .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
}

//extension UILabel {
//    public var fontSize: Binder<CGFloat> {
//        return Binder(self) { label, fontSize in
//            label.font = UIFont.systemFont(ofSize: fontSize)
//        }
//    }
//}

extension Reactive where Base: UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self.base) { label, fontSize in
                label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}
