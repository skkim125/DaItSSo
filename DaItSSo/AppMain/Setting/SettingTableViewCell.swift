//
//  SettingTableViewCell.swift
//  DaItSSo
//
//  Created by 김상규 on 6/15/24.
//

import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {

    lazy var settingLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        contentView.addSubview(settingLabel)
    }
    
    func configureLayout() {
        settingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(20)
        }
    }
    
    func configureSettingLabel(title: String) {
        settingLabel.text = title
    }
}
