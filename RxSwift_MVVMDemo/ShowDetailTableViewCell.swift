//
//  ShowDetailTableViewCell.swift
//  RxSwift_MVVMDemo
//
//  Created by 楷岷 張 on 2018/8/17.
//  Copyright © 2018年 Min. All rights reserved.
//

import UIKit

class ShowDetailTableViewCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18.0)
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        contentView.addSubviews([titleLabel, detailLabel])
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[titleLabel]-10-|",
            options: [],
            metrics: nil,
            views: ["titleLabel": titleLabel, "detailLabel": detailLabel]))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[detailLabel]-10-|",
            options: [],
            metrics: nil,
            views: ["titleLabel": titleLabel, "detailLabel": detailLabel]))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[titleLabel]-10-[detailLabel]-10-|",
            options: [],
            metrics: nil,
            views: ["titleLabel": titleLabel, "detailLabel": detailLabel]))
    }
}
