//
//  RecentSearchTableViewCell.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit
import SnapKit

class RecentSearchTableViewCell: UITableViewCell {
    
    let clockImgView = {
        let imgView = UIImageView(image: UIImage(systemName: "clock"))
        imgView.tintColor = .appDarkGray
        imgView.contentMode = .scaleAspectFit
        
        return imgView
    }()
    let recentSearchLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .appDarkGray
        
        return label
    }()
    lazy var deleteButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .appDarkGray
        
        return button
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
        // MARK: addSubView()
        contentView.addSubview(clockImgView)
        contentView.addSubview(recentSearchLabel)
        contentView.addSubview(deleteButton)
    }
    
    func configureLayout() {
        clockImgView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.size.equalTo(18)
        }
        
        recentSearchLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(clockImgView)
            make.leading.equalTo(clockImgView.snp.trailing).offset(15)
            make.height.equalTo(clockImgView)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(clockImgView)
            make.leading.equalTo(recentSearchLabel.snp.trailing).offset(15)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.size.equalTo(clockImgView)
        }
    }
    
    func configureCellUI(search: String) {
        recentSearchLabel.text = search
    }
}
