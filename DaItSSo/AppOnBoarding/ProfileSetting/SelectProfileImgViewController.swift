//
//  ChooseProfileImgViewController.swift
//  DaItSSo
//
//  Created by 김상규 on 6/13/24.
//

import UIKit

class SelectProfileImgViewController: BaseViewController {
    
    lazy var selectedProfileImgButton = ProfileButton(profileImgType: .isSelected)
    lazy var profileImgView = UIImageView()
    lazy var selectedProfileImgSubButton = ProfileSubButton()
    
    lazy var collectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.selectProfileCollectionViewLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.register(ProfileImgCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImgCollectionViewCell.id)
        
        return cv
    }()
    
    private let userDefaults = UserDefaultsManager.shared
    var navTitle: SetNavigationTitle = .firstProfile
    var selectedProfile: String = ""
    
    override func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.backButtonImg, style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.title = navTitle.navTitle
    }
    
    @objc private func backButtonClicked() {
        switch navTitle{
        case .firstProfile:
            userDefaults.profile = selectedProfile
        default:
            break
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    override func configureHierarchy() {
        view.addSubview(selectedProfileImgButton)
        view.addSubview(selectedProfileImgSubButton)
        selectedProfileImgButton.addSubview(profileImgView)
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        selectedProfileImgButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(120)
        }
        
        profileImgView.snp.makeConstraints { make in
            make.size.edges.equalTo(selectedProfileImgButton)
        }
        
        selectedProfileImgSubButton.snp.makeConstraints { make in
            make.bottom.equalTo(selectedProfileImgButton.snp.bottom).inset(10)
            make.leading.equalTo(selectedProfileImgButton.snp.centerX).offset(30)
            make.size.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(selectedProfileImgButton.snp.bottom).offset(30)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        profileImgView.image = UIImage(named: selectedProfile)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        switch navTitle{
        case .firstProfile:
            userDefaults.profile = selectedProfile
        case .editProfile:
            userDefaults.editProfile = selectedProfile
        default:
            break
        }
    }
}

extension SelectProfileImgViewController {
    func updateImageView(_ cell: ProfileImgCollectionViewCell, imageView: UIImageView, defaultImg: ProfileImg ) {
        let isEqual = profileImgView.image == UIImage(named: defaultImg.rawValue)
        cell.configureCellUI(image: defaultImg.rawValue, profileType: isEqual ? .isSelected : .unSelected)
    }
}

extension SelectProfileImgViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileImg.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImgCollectionViewCell.id, for: indexPath) as! ProfileImgCollectionViewCell
        let img = ProfileImg.allCases[indexPath.item]
        cell.isUserInteractionEnabled = true
        updateImageView(cell, imageView: profileImgView, defaultImg: img)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProfileImgCollectionViewCell
        let img = ProfileImg.allCases[indexPath.item]
        profileImgView.image = UIImage(named: img.rawValue)
        selectedProfile = img.rawValue
        
        updateImageView(cell, imageView: profileImgView, defaultImg: img)
        
        collectionView.reloadData()
    }
}
