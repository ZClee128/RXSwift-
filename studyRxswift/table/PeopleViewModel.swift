//
//  PeopleViewModel.swift
//  studyRxswift
//
//  Created by zclee on 2019/2/28.
//  Copyright © 2019 zclee. All rights reserved.
//

import Foundation
import RxSwift
struct PeopleListModel {
    let data = Observable.just([
        People(name: "张三", age: 14),
        People(name: "李四", age: 24),
        People(name: "王五", age: 34),
        People(name: "赵六", age: 44),
    ])
    
}
