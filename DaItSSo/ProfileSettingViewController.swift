//
//  ProfileSettingViewController.swift
//  DaItSSo
//
//  Created by 김상규 on 6/13/24.
//

import UIKit
import SnapKit

class ProfileSettingViewController: UIViewController {
    
    lazy var setProfileImgButton = ProfileButton(profileImgView)
    lazy var profileImgView = UIImageView()
            
    lazy var setProfileImgSub = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.setImage(UIImage(systemName: "camera"), for: .highlighted)
        button.tintAdjustmentMode = .automatic
        button.contentMode = .center
        button.clipsToBounds = true
        button.tintColor = .white
        button.backgroundColor = .mainColor
        
        return button
    }()
    
    lazy var nicknameTextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.placeholder = "닉네임을 입력해주세요"
        
        return tf
    }()
    
    lazy var dividerLine = {
        let view = UIView()
        view.backgroundColor = .appLightGray
        
        return view
    }()
    
    lazy var checkNicknameLabel = {
        let label = UILabel()
        label.text = "닉네임에 @ 는 포함할 수 없어요."
        label.textColor = .mainColor
        label.font = .systemFont(ofSize: 13)
        
        return label
    }()
    
    lazy var loginButton = PointButton(title: "완료")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        setUI()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "Profile Setting"
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(leftButtonTapped))
        navigationController?.navigationBar.tintColor = UIColor.appBlack
    }
    
    @objc func leftButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureHierarchy() {
        // MARK: addSubView()
        view.addSubview(setProfileImgButton)
        view.addSubview(setProfileImgSub)
        view.addSubview(nicknameTextField)
        view.addSubview(dividerLine)
        view.addSubview(checkNicknameLabel)
        view.addSubview(loginButton)
    }
    
    func configureLayout() {
        setProfileImgButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(120)
        }
        
        profileImgView.snp.makeConstraints { make in
            make.size.edges.equalTo(setProfileImgButton)
        }
        
        setProfileImgSub.snp.makeConstraints { make in
            make.bottom.equalTo(setProfileImgButton.snp.bottom).inset(10)
            make.leading.equalTo(setProfileImgButton.snp.centerX).offset(30)
            make.size.equalTo(30)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(setProfileImgButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(40)
        }
        
        dividerLine.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(nicknameTextField)
            make.bottom.equalTo(nicknameTextField.snp.bottom).offset(10)
            make.height.equalTo(1)
        }
        
        checkNicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(25)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(checkNicknameLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(60)
        }
    }
    
    func setUI() {
        profileImgView.image = UIImage(named: "profile_0")
        setProfileImgButton.addTarget(self, action: #selector(setProfileImgButtonClicked), for: .touchUpInside)
        setProfileImgSub.addTarget(self, action: #selector(setProfileImgButtonClicked), for: .touchUpInside)
    }
    
    @objc func setProfileImgButtonClicked() {
        print(#function)
        let vc = ChooseProfileImgViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setProfileImgButton.layer.cornerRadius = setProfileImgButton.bounds.width/2
        setProfileImgSub.layer.cornerRadius = setProfileImgSub.bounds.width/2
    }
}
