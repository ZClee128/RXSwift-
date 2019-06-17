//
//  DisposeViewController.swift
//  studyRxswift
//
//  Created by zclee on 2019/3/1.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DisposeViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ob = Observable.of(1,2,3)
        
        let sub = ob.subscribe{ event in
                print(event)
        }
        
        sub.dispose()
        
        sub.disposed(by: disposeBag)
        // Do any additional setup after loading the view.
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
