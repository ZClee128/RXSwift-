//
//  UIButtonViewController.swift
//  studyRxswift
//
//  Created by lee on 2019/7/23.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UIButtonViewController: UIViewController {

    let disposeBag = DisposeBag();
    
    var clickBtn: UIButton!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white;
//        假设我们想实现点击按钮后，弹出一个消息提示框
        self.clickBtn = UIButton.init(type: .system)
        self.clickBtn.frame = CGRect(x: 100, y: 100, width: 200, height: 200);
        self.view.addSubview(self.clickBtn)
        self.clickBtn.backgroundColor = .red;
        self.clickBtn.setTitle("点击", for: .normal)
//        第一种写法
//        self.clickBtn.rx.tap
//            .subscribe (onNext: { [weak self] in
//                self?.showMessage("按钮被点击")
//            }).disposed(by: disposeBag)
        
//        第二种写法
//        self.clickBtn.rx.tap
//            .bind { [weak self] in
//                self?.showMessage("按钮点击")
//            }.disposed(by: disposeBag)
//        self.bindBtnTitle()
//        self.isEnabled()
        self.moreSelected()
    }
    
    //显示消息提示框
    func showMessage(_ text: String) {
        let alertController = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func bindBtnTitle() {
//        创建一个定时器
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        
//        timer.map {"计算\($0)"}
//            .bind { (str) in
//                self.clickBtn.setTitle(str, for: .normal)
//            }.disposed(by: disposeBag);
        
//        富文本
//        timer.map(bindAttributedTitle)
//            .bind(to: self.clickBtn.rx.attributedTitle())
//            .disposed(by: disposeBag)
        
//        绑定图片
//        timer.map({
//            let name = $0 % 2 == 0 ? "img_operation_failure" : "img_operation_success"
//            return UIImage(named: name)!
//        })
//        .bind(to: self.clickBtn.rx.image())
//        .disposed(by: disposeBag)
        
//        绑定背景图片
        timer.map({
            let name = $0 % 2 == 0 ? "img_operation_failure" : "img_operation_success"
            return UIImage(named: name)!
        })
        .bind(to: self.clickBtn.rx.backgroundImage())
        .disposed(by: disposeBag)
    }

//    将数字转成对应的富文本
    func bindAttributedTitle(ms: NSInteger) -> NSMutableAttributedString {
        let string = String(format: "%0.2d:%0.2d.%0.1d",
                            arguments: [(ms / 600) % 600, (ms % 600 ) / 10, ms % 10])
        //富文本设置
        let attributeString = NSMutableAttributedString(string: string)
        //从文本0开始6个字符字体HelveticaNeue-Bold,16号
        attributeString.addAttribute(NSAttributedString.Key.font,
                                     value: UIFont(name: "HelveticaNeue-Bold", size: 16)!,
                                     range: NSMakeRange(0, 5))
        //设置字体颜色
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor,
                                     value: UIColor.white, range: NSMakeRange(0, 5))
        //设置文字背景颜色
        attributeString.addAttribute(NSAttributedString.Key.backgroundColor,
                                     value: UIColor.orange, range: NSMakeRange(0, 5))
        return attributeString
    }
    
    func isEnabled() {
        let switchBtn: UISwitch = UISwitch.init(frame: CGRect(x: 100, y: 200, width: 50, height: 50))
        self.view.addSubview(switchBtn)
        switchBtn.rx.isOn
            .bind(to: self.clickBtn.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func moreSelected() {
        let oneBtn = UIButton.init(type: .system)
        oneBtn.frame = CGRect(x: 50, y: 350, width: 100, height: 30)
        oneBtn.setTitle("one btn", for: .normal)
        self.view.addSubview(oneBtn)
        let twoBtn = UIButton.init(type: .system)
        twoBtn.frame = CGRect(x: 150, y: 350, width: 100, height: 30)
        twoBtn.setTitle("two btn", for: .normal)
        self.view.addSubview(twoBtn)
        let threeBtn = UIButton.init(type: .system)
        threeBtn.frame = CGRect(x: 250, y: 350, width: 100, height: 30)
        threeBtn.setTitle("three btn", for: .normal)
        self.view.addSubview(threeBtn)
        
        oneBtn.isSelected = true
        
        let btns = [oneBtn,twoBtn,threeBtn].map({$0!})
        
        //创建一个可观察序列，它可以发送最后一次点击的按钮（也就是我们需要选中的按钮）
        let selectBtn = Observable.from(btns.map({ btn in
            btn.rx.tap.map({btn})
        })).merge()
        
        //对于每一个按钮都对selectedButton进行订阅，根据它是否是当前选中的按钮绑定isSelected属性
        for button in btns {
            selectBtn.map { $0 == button }
                .bind(to: button.rx.isSelected)
                .disposed(by: disposeBag)
        }
    }
}
