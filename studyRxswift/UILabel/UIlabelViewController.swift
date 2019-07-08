//
//  UIlabelViewController.swift
//  studyRxswift
//
//  Created by lee on 2019/7/8.
//  Copyright © 2019 zclee. All rights reserved.
//

/**
 RxSwift是一个用于与 Swift 语言交互的框架，但它只是基础，并不能用来进行用户交互、网络请求等。
 而 RxCocoa 是让 Cocoa APIs 更容易使用响应式编程的一个框架。RxCocoa 能够让我们方便地进行响应式网络请求、响应式的用户交互、绑定数据模型到 UI 控件等等。而且大多数的 UIKit 控件都有响应式扩展，它们都是通过 rx 属性进行使用。
 */

import UIKit
import RxCocoa
import RxSwift

class UIlabelViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        //创建文本标签
        let label = UILabel(frame:CGRect(x:88, y:88, width:300, height:100))
        self.view.addSubview(label)
        
        //创建一个计时器（每0.1秒发送一个索引数）
        let timer = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
        
        //将已过去的时间格式化成想要的字符串，并绑定到label上
//        timer.map{ String(format: "%0.2d:%0.2d.%0.1d",
//                          arguments: [($0 / 600) % 600, ($0 % 600 ) / 10, $0 % 10]) }
//            .bind(to: label.rx.text)
//            .disposed(by: disposeBag)
        
//        富文本
        timer.map(formatTimeInterval)
            .bind(to: label.rx.attributedText)
            .disposed(by: disposeBag)
    }
    
    //将数字转成对应的富文本
    func formatTimeInterval(ms: NSInteger) -> NSMutableAttributedString {
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
}
