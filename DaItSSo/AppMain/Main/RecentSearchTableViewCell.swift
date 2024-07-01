//
//  RecentSearchTableViewCell.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit
import SnapKit

final class RecentSearchTableViewCell: BaseTableViewCell {
    
    private let clockImgView = {
        let imgView = UIImageView(image: UIImage(systemName: "clock"))
        imgView.tintColor = .appDarkGray
        imgView.contentMode = .scaleAspectFit
        
        return imgView
    }()
    private let recentSearchLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .appDarkGray
        
        return label
    }()
    private let deleteButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .appDarkGray
        
        return button
    }()
    
    var searchText = ""
    
    override func configureHierarchy() {
        contentView.addSubview(clockImgView)
        contentView.addSubview(recentSearchLabel)
        contentView.addSubview(deleteButton)
    }
    
    override func configureLayout() {
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
        searchText = search
    }
    
    func deleteButtonAddTarget(target: Any?, action: Selector) {
        deleteButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
