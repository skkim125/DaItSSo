//
//  ProfileSettingViewController.swift
//  DaItSSo
//
//  Created by 김상규 on 6/13/24.
//

import UIKit
import SnapKit

class ProfileSettingViewController: UIViewController {
    
    private lazy var setProfileImgButton = ProfileButton(profileImgType: .isSelected)
    private lazy var profileImgView = UIImageView()
    private lazy var setProfileImgSubButton = ProfileSubButton()
    
    lazy var nicknameTextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.placeholder = "닉네임을 입력해주세요"
        tf.delegate = self
        
        return tf
    }()
    
    private lazy var dividerLine = DividerLine(color: UIColor.appLightGray)
    
    private lazy var checkNicknameLabel = {
        let label = UILabel()
        label.textColor = .appMainColor
        label.font = .systemFont(ofSize: 13)
        
        return label
    }()
    
    private lazy var loginButton = PointButton(title: "완료")
    
    var userDefaults = UserDefaultsManager.shared
    let profileList = ProfileImg.allCases
    lazy var profileViewType: ProfileViewType = .first
    lazy var profileImg: String = ""
    lazy var editProfileImg: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        setUI()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = profileViewType.rawValue
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationController?.navigationBar.tintColor = UIColor.appBlack
        
        switch profileViewType {
        case .first:
            break
        case .edit:
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonClicked))
        }
    }
    
    @objc private func saveButtonClicked() {
        UserDefaultsManager.shared.profile = editProfileImg
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func backButtonTapped() {
        switch profileViewType {
        case .first:
            UserDefaultsManager.shared.profile = ""
        case .edit:
            UserDefaultsManager.shared.profile = profileImg
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func configureHierarchy() {
        // MARK: addSubView()
        view.addSubview(setProfileImgButton)
        setProfileImgButton.addSubview(profileImgView)
        view.addSubview(setProfileImgSubButton)
        view.addSubview(nicknameTextField)
        view.addSubview(dividerLine)
        view.addSubview(checkNicknameLabel)
        view.addSubview(loginButton)
    }
    
    private func configureLayout() {
        setProfileImgButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(120)
        }
        
        profileImgView.snp.makeConstraints { make in
            make.size.edges.equalTo(setProfileImgButton)
        }
        
        setProfileImgSubButton.snp.makeConstraints { make in
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
    
    private func setUI() {
        profileImgView.image = UIImage(named: profileImg)
        setProfileImgButton.addTarget(self, action: #selector(setProfileImgButtonClicked), for: .touchUpInside)
        setProfileImgSubButton.addTarget(self, action: #selector(setProfileImgButtonClicked), for: .touchUpInside)
        
        switch profileViewType {
        case .first:
            loginButton.addTarget(self, action: #selector(moveMainView), for: .touchUpInside)
            loginButton.isEnabled = false
            loginButton.backgroundColor = .appLightGray
        case .edit:
            loginButton.isHidden = true
        }

    }
    
    @objc private func setProfileImgButtonClicked() {
        let vc = SelectProfileImgViewController()
        vc.profileViewType = profileViewType
        switch profileViewType {
        case .first:
            vc.selectedProfile = profileImg
        case .edit:
            vc.selectedProfile = editProfileImg
        }
        navigationController?.pushViewController(vc, animated: true)
        print(vc.selectedProfile)
    }
    
    @objc private func moveMainView() {
        
        UserDefaultsManager.shared.isStart = true
        UserDefaultsManager.shared.nickname = nicknameTextField.text!
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let vc = TabViewController()
        
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setProfileImgButton.layer.cornerRadius = setProfileImgButton.frame.width / 2
        setProfileImgSubButton.layer.cornerRadius = setProfileImgSubButton.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if profileImg.isEmpty {
            profileImg = ProfileImg.allCases.randomElement()!.rawValue
            profileImgView.image = UIImage(named: profileImg)
        } else {
            switch profileViewType {
            case .first:
                profileImg = userDefaults.profile
                profileImgView.image = UIImage(named: profileImg)
                nicknameTextField.text = nil
                checkNicknameLabel.text = nil
                loginButton.isEnabled = false
                loginButton.backgroundColor = .appLightGray
                
            case .edit:
                editProfileImg = userDefaults.editProfile
                profileImgView.image = UIImage(named: editProfileImg)
                print("editProfileImg = \(editProfileImg)")
                
                nicknameTextField.text = userDefaults.nickname
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        switch profileViewType {
        case .first:
            break
        case .edit:
            editProfileImg = userDefaults.profile
        }
    }
}

extension ProfileSettingViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if let text = textField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty {
            print(#function, text)
            
            guard text.count >= 2 && text.count < 10 else {
                loginButton.isEnabled = false
                loginButton.backgroundColor = .appLightGray
                checkNicknameLabel.text = "2글자 이상 10글자 미만으로 설정해주세요"
                
                return
            }
            
            for i in text {
                guard Int(String(i)) == nil else {
                    loginButton.isEnabled = false
                    loginButton.backgroundColor = .appLightGray
                    checkNicknameLabel.text = "닉네임에 숫자는 포함할 수 없어요"
                    
                    return
                }
            }
            
            let specialStringArr = ["@", "#", "$", "%"]
            
            for i in specialStringArr {
                guard !text.hasPrefix(i) else {
                    loginButton.isEnabled = false
                    loginButton.backgroundColor = .appLightGray
                    checkNicknameLabel.text = "닉네임에 \(i)는 포함할 수 없어요"
                    
                    return
                }
            }
            
            loginButton.isEnabled = true
            loginButton.backgroundColor = .appMainColor
            checkNicknameLabel.text = "사용할 수 있는 닉네임이에요!"
            
        }
    }
}
