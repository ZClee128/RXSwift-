//
//  UISliderViewController.swift
//  studyRxswift
//
//  Created by lee on 2019/7/26.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit

class UISliderViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        滑块
        let slider = UISlider.init(frame: CGRect(x: 100, y: 100, width: 100, height: 20))
        self.view.addSubview(slider)
        slider.value = 0.1
        slider.rx.value.asObservable()
            .subscribe(onNext: {
                print("滑块当前值为：\($0)")
            })
            .disposed(by: disposeBag)
        
//        计步器
        let step = UIStepper.init(frame: CGRect(x: 100, y: 200, width: 100, height: 20))
        self.view.addSubview(step)
        step.rx.value.asObservable()
            .subscribe(onNext: {
                print("计步器当前值为：\($0)")
            })
            .disposed(by: disposeBag)
        
//        现在我们使用滑块（slider）来控制 stepper 的步长。
        slider.rx.value
            .map{ Double($0) }  //由于slider值为Float类型，而stepper的stepValue为Double类型，因此需要转换
            .bind(to: step.rx.stepValue)
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
