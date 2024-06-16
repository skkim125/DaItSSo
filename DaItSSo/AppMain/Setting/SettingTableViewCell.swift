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
    lazy var shoppingCountLabel = UILabel()
    lazy var shoppingImage = {
        let imgView = UIImageView(image: UIImage(systemName: "handbag.fill"))
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = .black
        
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
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
        settingLabel.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    func configureMyShoppingCellHierarchy() {
        contentView.addSubview(shoppingCountLabel)
        contentView.addSubview(shoppingImage)
    }
    
    func configureMyShoppingCellLayout() {
        shoppingCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing).inset(20)
        }
        
        shoppingImage.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.greaterThanOrEqualTo(settingLabel.snp.trailing).offset(20)
            make.trailing.equalTo(shoppingCountLabel.snp.leading).inset(-5)
            make.size.equalTo(20)
        }
    }
    
    func configureMyShoppingCellUI(count: Int) {
        let string = NSMutableAttributedString(string: "\(count)개의 상품")
        string.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: ("\(count)개의 상품" as NSString).range(of: "\(count)개"))
        shoppingCountLabel.attributedText = string
    }
}
