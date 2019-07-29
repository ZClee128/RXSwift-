//
//  UIDatePickerViewController.swift
//  studyRxswift
//
//  Created by lee on 2019/7/29.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UIDatePickerViewController: BaseViewController {

    var datePicker : UIDatePicker!
    var lab : UILabel!
    var startBtn : UIButton!
    
    var leftTime = Variable(TimeInterval(180))
    
    //当前倒计时是否结束
    let countDownStopped = Variable(true)
    
//    日期格式化
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 100, width: 375, height: 400))
        self.datePicker.datePickerMode = UIDatePicker.Mode.countDownTimer
        self.view.addSubview(self.datePicker)
        
        self.lab = UILabel(frame: CGRect(x: 0, y: 550, width: 400, height: 50))
        self.view.addSubview(self.lab)
        
//        self.datePicker.rx.date
//            .map{ [weak self] in
//                "当前选择的时间:" + self!.dateFormatter.string(from: $0)
//            }.bind(to: self.lab.rx.text).disposed(by: disposeBag)
        self.countDown()
    }
    
//    写一个通过时间选择器来实现倒计时
    func countDown()  {
        self.startBtn = UIButton(type: .system)
        self.startBtn.frame = CGRect(x: 0, y: 600, width: 400, height: 50)
        self.view.addSubview(self.startBtn)
        self.startBtn.setTitleColor(.red, for: .normal)
        self.startBtn.setTitleColor(.gray, for: .disabled)
        DispatchQueue.main.async {
            _ = self.datePicker.rx.countDownDuration <-> self.leftTime
        }
        
//        绑定按钮内容
        Observable.combineLatest(leftTime.asObservable(),countDownStopped.asObservable()) { leftTimeValue, countValue in
            if countValue {
                return "开始"
            }else {
                return "倒计时开始，还有 \(Int(leftTimeValue)) 秒..."
            }
        }.bind(to: self.startBtn.rx.title()).disposed(by: disposeBag)
        
        //绑定button和datepicker状态（在倒计过程中，按钮和时间选择组件不可用)
        countDownStopped.asDriver().drive(self.startBtn.rx.isEnabled).disposed(by: disposeBag)
        countDownStopped.asDriver().drive(self.datePicker.rx.isEnabled).disposed(by: disposeBag)
        
        self.startBtn.rx.tap
            .bind{ [weak self] in
                self?.startClicked()
        }.disposed(by: disposeBag)
        
    }
    
    //开始倒计时
    func startClicked() {
        //开始倒计时
        self.countDownStopped.value = false
        
        //创建一个计时器
        Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .takeUntil(countDownStopped.asObservable().filter{ $0 }) //倒计时结束时停止计时器
            .subscribe { event in
                //每次剩余时间减1
                self.leftTime.value -= 1
                // 如果剩余时间小于等于0
                if(self.leftTime.value == 0) {
                    print("倒计时结束！")
                    //结束倒计时
                    self.countDownStopped.value = true
                    //重制时间
                    self.leftTime.value = 180
                }
            }.disposed(by: disposeBag)
    }

}
