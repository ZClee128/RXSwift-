//
//  BidirectionalDataViewController.swift
//  studyRxswift
//
//  Created by lee on 2019/7/29.
//  Copyright © 2019 zclee. All rights reserved.
//

// 双向数据绑定
import UIKit
import RxSwift
import RxCocoa

//定义一个vm
struct UserViewModel {
    let userName = BehaviorRelay(value: "guset")
    
    lazy var userInfo = {
        return self.userName.asObservable().map{
            $0 == "Congge" ? "你是管理员" : "你是普通用户"
        }.share(replay: 1)
    }()
}

class BidirectionalDataViewController: BaseViewController {
    
//    然后我们写个简单的双向绑定
    
    var textField : UITextField!
    var lab : UILabel!
    var userVM = UserViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField = UITextField(frame: CGRect(x: 50, y: 100, width: 100, height: 50))
        self.textField.borderStyle = UITextField.BorderStyle.roundedRect
        self.view.addSubview(self.textField)
        
        self.lab = UILabel(frame: CGRect(x: 50, y: 200, width: 200, height: 50))
        self.view.addSubview(self.lab)
        
//        将用户名和textfield双向绑定
//        self.userVM.userName.asObservable().bind(to: self.textField.rx.text).disposed(by: disposeBag)
//        self.textField.rx.text.orEmpty.bind(to: self.userVM.userName).disposed(by: disposeBag)

        _ = self.textField.rx.textInput <-> self.userVM.userName
//        将用户的信息绑定到lab上
        self.userVM.userInfo.asObservable().bind(to: self.lab.rx.text).disposed(by: disposeBag)
    }
    
//    自定义双向绑定操作符（operator）
    

}
