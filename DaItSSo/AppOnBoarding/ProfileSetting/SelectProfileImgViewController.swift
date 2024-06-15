//
//  ChooseProfileImgViewController.swift
//  DaItSSo
//
//  Created by 김상규 on 6/13/24.
//

import UIKit

class SelectProfileImgViewController: UIViewController {
    
    lazy var selectedProfileImgButton = ProfileButton(profileImgType: .isSelected)
    lazy var profileImgView = UIImageView()
    lazy var selectedProfileImgSubButton = ProfileSubButton()
    
    lazy var collectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.register(ProfileImgCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImgCollectionViewCell.id)
        
        return cv
    }()
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellSpacing: CGFloat = 10
        let sectionSpacing: CGFloat = 10
        let width = UIScreen.main.bounds.width-(sectionSpacing*2 + cellSpacing*3)
        
        layout.itemSize = CGSize(width: width/4, height: width/4)
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = .init(top: 0, left: sectionSpacing, bottom: 0, right: sectionSpacing)
        
        return layout
    }
    
    var profileViewType: ProfileViewType?
    var selectedProfile: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        profileImgViewUI()
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.backButtonImg, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.title = "Profile Setting"
    }
    
    @objc private func backButtonTapped() {
        if let type = profileViewType {
            switch type {
            case .first:
                if let img = selectedProfile {
                    UserDefaultsManager.shared.profile = img
                }
            case .edit:
                break
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func configureHierarchy() {
        view.addSubview(selectedProfileImgButton)
        view.addSubview(selectedProfileImgSubButton)
        selectedProfileImgButton.addSubview(profileImgView)
        view.addSubview(collectionView)
    }
    
    func configureLayout() {
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
    
    func profileImgViewUI() {
        if let profile = selectedProfile {
            profileImgView.image = UIImage(named: profile)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let type = profileViewType {
            switch type {
            case .first:
                if let profile = selectedProfile {
                    UserDefaultsManager.shared.profile = profile
                }
            case .edit:
                if let profile = selectedProfile {
                    UserDefaultsManager.shared.editProfile = profile
                    print(#function, UserDefaultsManager.shared.editProfile)
                }
            }
        }
    }
}

extension SelectProfileImgViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UIImage.profileImgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImgCollectionViewCell.id, for: indexPath) as! ProfileImgCollectionViewCell
        let img = UIImage.profileImgArray[indexPath.item]
        
        guard let profile = selectedProfile else {
            print(#function, "guard문 걸림")
            return cell
        }
        
        if profile == img {
            cell.configureCellUI(image: img, profileType: .isSelected)
            print("선택된 셀 = \(indexPath.item)")
        } else {
            cell.configureCellUI(image: img, profileType: .unSelected)
            print("선택되지 않은 셀 = \(indexPath.item)")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("선택된 항목 인덱스: \(indexPath.row)")
        let img = UIImage.profileImgArray[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath) as! ProfileImgCollectionViewCell
        profileImgView.image = UIImage(named: img)
        
        print("선택된 이미지: \(img)")
        selectedProfile = img
        
        if cell.profileImgView.image == UIImage(named: img) {
            cell.configureCellUI(image: img, profileType: .isSelected)
            print("선택된 셀 = \(indexPath.item)")
        } else {
            cell.configureCellUI(image: img, profileType: .unSelected)
            print("선택되지 않은 셀 = \(indexPath.item)")
        }
        
        collectionView.reloadData()
    }
}
