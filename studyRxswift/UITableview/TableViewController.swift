//
//  TableViewController.swift
//  studyRxswift
//
//  Created by lee on 2019/8/5.
//  Copyright © 2019 zclee. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class TableViewController: BaseViewController {

    var myTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTable = UITableView(frame: CGRect(x: 0, y: 88, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-88), style: .plain)
        self.view.addSubview(self.myTable)
        self.myTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        设置代理
        self.myTable.rx.setDelegate(self).disposed(by: disposeBag)
//        需要设置为true才能移动cell
//        self.myTable.isEditing = true

        let dataSoure = NSMutableArray.init()
        dataSoure.addObjects(from: [
            "小姐姐",
            "小哥哥",
            "大叔",
            "小萝莉",
            ])
//        初始化数据
        let items = Observable.just(dataSoure)
        
        //设置单元格数据（其实就是对 cellForRowAt 的封装）
        items.bind(to: self.myTable.rx.items){ (tableview, row, element) in
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell")
            cell?.accessoryType = .detailDisclosureButton
            cell?.textLabel?.text = "\(row): \(element)"
            return cell!
        }.disposed(by: disposeBag)
        
//        获取点击行
        self.myTable.rx.itemSelected.subscribe(onNext: { [weak self] (index) in
             print("\(index.row)")
//            self?.showAlert(title: "点击第几行", message: "\(index.row)")
        }).disposed(by: disposeBag)
        
//        获取点击内容
        self.myTable.rx.modelSelected(String.self).subscribe(onNext: { [weak self] (title) in
            print("\(title)")
//            self?.showAlert(title: "点击内容", message: "\(title)")
        }).disposed(by: disposeBag)
        
        
        // 获取选中项的索引和内容
        Observable.zip(self.myTable.rx.itemSelected, self.myTable.rx.modelSelected(String.self)).bind { indexPath, item in
            print("选中项的indexPath为: \(indexPath)")
            print("选中项的标题为: \(item)")
            }.disposed(by: disposeBag)
        
//        获取被取消选中项的索引
        self.myTable.rx.itemDeselected.subscribe(onNext: { (index) in
            print("点击取消行：\(index.row)")
        }).disposed(by: disposeBag)
        
//        获取被取消选中项的内容
        self.myTable.rx.modelDeselected(String.self).subscribe(onNext: { (title) in
            print("点击取消内容：\(title)")
        }).disposed(by: disposeBag)
        
//        获取删除项的索引
        self.myTable.rx.itemDeleted.subscribe(onNext: { indexPath in
            print("删除项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)

        //获取删除项的内容
        self.myTable.rx.modelDeleted(String.self).subscribe(onNext: { item in
            print("删除项的的标题为：\(item)")
        }).disposed(by: disposeBag)
        
//        获取移动项的索引
        self.myTable.rx.itemMoved.subscribe(onNext: { sourceIndexPath, destinationIndexPath in
            print("移动项原来的indexPath为：\(sourceIndexPath.row)")
            print("移动项现在的indexPath为：\(destinationIndexPath.row)")
        }).disposed(by: disposeBag)
        
        //获取插入项的索引
        self.myTable.rx.itemInserted.subscribe(onNext: { indexPath in
            print("插入项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        // 单元格将要显示出来的事件响应
         self.myTable.rx.willDisplayCell.subscribe(onNext: { cell, indexPath in
            print("将要显示的indexPath为：\(indexPath)")
            print("将要显示的cell为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        // 获取点击的尾部图标的索引
        self.myTable.rx.itemAccessoryButtonTapped.subscribe(onNext: { indexPath in
            print("尾部项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)

    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel))
        self.present(alert, animated: true)
    }

}

extension TableViewController: UITableViewDelegate {
//    返回编辑状态
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .insert
    }
}
