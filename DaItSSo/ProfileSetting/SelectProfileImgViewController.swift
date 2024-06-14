//
//  ChooseProfileImgViewController.swift
//  DaItSSo
//
//  Created by 김상규 on 6/13/24.
//

import UIKit

class SelectProfileImgViewController: UIViewController {
    
    lazy var choosedProfileImgButton = ProfileButton(profileImgView)
    lazy var profileImgView = UIImageView()
    
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
        layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        
        return layout
    }
    
    var selectedProfile: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        choosedProfileImgButton.isEnabled = false
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.backButtonImg, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.title = "Profile Setting"
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureHierarchy() {
        view.addSubview(choosedProfileImgButton)
        view.addSubview(collectionView)
    }
    
    func configureLayout() {
        choosedProfileImgButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(120)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(choosedProfileImgButton.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func viewDidLayoutSubviews() {
        choosedProfileImgButton.layer.cornerRadius = choosedProfileImgButton.frame.width / 2
    }
}

extension SelectProfileImgViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UIImage.profileImgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImgCollectionViewCell.id, for: indexPath) as! ProfileImgCollectionViewCell
        let img = UIImage.profileImgArray[indexPath.item]
        cell.profileImgView.image = UIImage(named: img)
        cell.profileImgButton.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCell = collectionView.cellForItem(at: indexPath) as! ProfileImgCollectionViewCell
        let img = UIImage.profileImgArray[indexPath.item]
        
        if selectedCell.profileImgView.image == UIImage(named: img) {
            self.profileImgView = profileImgView
        } else {
            
        }
        
    }
}
