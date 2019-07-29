//
//  SwitchViewController.swift
//  studyRxswift
//
//  Created by lee on 2019/7/26.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SwitchViewController: UIViewController {

    let disposeBag = DisposeBag();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
//        UISwitch 用法
        let switchBtn: UISwitch = UISwitch.init(frame: CGRect(x: 100, y: 200, width: 50, height: 50))
        self.view.addSubview(switchBtn)
        switchBtn.rx.isOn.asObservable().subscribe(onNext: { (on) in
            print(on)
        }).disposed(by: disposeBag)
        self.UISegmented()
    }
    

    func UISegmented() {
        let seg = UISegmentedControl.init(items: ["one","two"])
        seg.frame = CGRect(x: 100, y: 300, width: 200, height: 50)
        self.view.addSubview(seg)
//        seg.rx.selectedSegmentIndex.asObservable()
//            .subscribe(onNext: { (index) in
//                print(index)
//            }).disposed(by: disposeBag)
        seg.selectedSegmentIndex = 0
        let imageView = UIImageView.init(frame: CGRect(x: 100, y: 351, width: 50, height: 50))
        self.view.addSubview(imageView)
        //创建一个当前需要显示的图片的可观察序列
        let imageObser : Observable<UIImage> = seg.rx.selectedSegmentIndex.asObservable()
                                                        .map({
                                                            let images = ["img_operation_failure", "img_operation_success"]
                                                            return UIImage(named: images[$0])!
                                                        })
        
        imageObser.bind(to: imageView.rx.image).disposed(by: disposeBag)
    }

}
