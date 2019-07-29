//
//  UIActivityIndicatorViewController.swift
//  studyRxswift
//
//  Created by lee on 2019/7/26.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UIActivityIndicatorViewController: UIViewController {

    let disposeBag = DisposeBag();
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        let activity = UIActivityIndicatorView.init(frame: CGRect(x: 200, y: 200, width: 50, height: 50))
        activity.color = .blue
        self.view.addSubview(activity)
        let switchBtn: UISwitch = UISwitch.init(frame: CGRect(x: 100, y: 200, width: 50, height: 50))
        self.view.addSubview(switchBtn)
//        switchBtn.rx.value
//            .bind(to: activity.rx.isAnimating)
//            .disposed(by: disposeBag)
        
        switchBtn.rx.value
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    



}
