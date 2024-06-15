//
//  MyProfileTableViewCell.swift
//  DaItSSo
//
//  Created by 김상규 on 6/15/24.
//

import UIKit
import SnapKit

class MyProfileTableViewCell: UITableViewCell {
    private lazy var profileButton = ProfileButton(profileImgType: .isSelected)
    private lazy var profileImgView = UIImageView()
    private lazy var labelStackView = {
        let sv = UIStackView(arrangedSubviews: [nicknameLabel, dateLabel])
        sv.axis = .vertical
        sv.spacing = 5
        
        return sv
    }()
    private lazy var nicknameLabel = {
        let label = UILabel()
        
        return label
    }()
    private lazy var dateLabel = {
        let label = UILabel()
        
        return label
    }()
    private lazy var rightChevronImg = {
        let imgView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = .appDarkGray
        
        return imgView
    }()
    var profileImg: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        contentView.addSubview(profileButton)
        profileButton.addSubview(profileImgView)
        contentView.addSubview(labelStackView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(rightChevronImg)
    }
    
    private func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(profileButton.snp.height)
        }
        
        profileImgView.snp.makeConstraints { make in
            make.size.edges.equalTo(profileButton)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(profileButton.snp.trailing).offset(15)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(30)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.top)
            make.horizontalEdges.equalTo(labelStackView.snp.horizontalEdges)
            make.height.equalTo(labelStackView.snp.height).multipliedBy(0.7)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.height.equalTo(labelStackView.snp.height).multipliedBy(0.3)
            make.horizontalEdges.equalTo(labelStackView.snp.horizontalEdges)
        }
        
        rightChevronImg.snp.makeConstraints { make in
            make.leading.equalTo(labelStackView.snp.trailing).offset(20)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.centerY.equalTo(profileButton.snp.centerY)
            make.size.equalTo(25)
        }
    }
    
    func configureMyProfileCellUI(image: String) {
        profileImgView.image = UIImage(named: image)
        nicknameLabel.text = UserDefaultsManager.shared.nickname
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
