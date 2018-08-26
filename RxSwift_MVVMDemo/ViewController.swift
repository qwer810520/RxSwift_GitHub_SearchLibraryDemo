//
//  ViewController.swift
//  RxSwift_MVVMDemo
//
//  Created by 楷岷 張 on 2018/8/14.
//  Copyright © 2018年 Min. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(ShowDetailTableViewCell.self, forCellReuseIdentifier: ShowDetailTableViewCell.identifier)
        return view
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 56))
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        //查詢條件輸入
        let searchAction = searchBar.rx.text.orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()     //防止重複事件
            .asObservable()
        
        //初始化ViewModel
        let viewModel = ViewModel(searchAction: searchAction)
        
        //綁定NavigationTitle
        viewModel.navigationTitle
            .bind(to: navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        //將Data綁定到tableView
        viewModel.repositories
            .bind(to: tableView.rx.items) { (tableView, row, data) in
                let cell = tableView.dequeueReusableCell(withIdentifier: ShowDetailTableViewCell.identifier) as! ShowDetailTableViewCell
                cell.titleLabel.text = data.name
                cell.detailLabel.text = data.htmlURL
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        //點擊Cell
        tableView.rx.modelSelected(GitHubRepository.self)
            .subscribe(onNext: { [weak self] (element) in
                self?.showAlert(title: element.fullName, message: element.description)
            })
            .disposed(by: rx.disposeBag)
        
        
        
        //點擊到Cell把點擊顯示的UI清掉
        tableView.rx.itemSelected
            .asObservable()
            .bind(to: tableView.rx.itemDeselected)
            .disposed(by: rx.disposeBag)
        
        //當搜尋到並確定有資料後，鍵盤縮下去
        viewModel.searchResult
            .map { !$0.items.isEmpty }
            .bind(to: view.rx.endEditing)
            .disposed(by: rx.disposeBag)
         */
        
        //查詢條件輸入
        let searchAction = searchBar.rx.text.orEmpty
            .asDriver()
            .throttle(0.5)  //間隔超過0.5秒才發送
            .distinctUntilChanged() //防止重複事件
        
        //initViewModel
        let viewModel = DriverViewModel(searchAction: searchAction)
        
        //綁定NavigationTitle
        viewModel.navigationTitle
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        //綁定TableView
        viewModel.repositories.drive(tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: ShowDetailTableViewCell.identifier) as! ShowDetailTableViewCell
                cell.titleLabel.text = element.name
                cell.detailLabel.text = element.htmlURL
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        //Cell點擊
        tableView.rx.modelSelected(GitHubRepository.self)
            .subscribe(onNext: { [weak self] in
                self?.showAlert(title: $0.fullName, message: $0.description)
            })
            .disposed(by: rx.disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserInterface()
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        view.addSubviews([tableView])
        
        tableView.tableHeaderView = searchBar
        tableView.sectionHeaderHeight = 56
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[tableView]|",
            options: [],
            metrics: nil,
            views: ["tableView": tableView]))
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[tableView]|",
            options: [],
            metrics: nil,
            views: ["tableView": tableView]))
        
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Check", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    open func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension Reactive where Base: UITableView {
    var itemDeselected: Binder<IndexPath> {
        return Binder(self.base, binding: { (tableView, indexPath) in
            tableView.deselectRow(at: indexPath, animated: true)
        })
    }
}

extension Reactive where Base: UIView {
    var endEditing: Binder<Bool> {
        return Binder(self.base, binding: { (view, bool) in
            view.endEditing(bool)
        })
    }
}

