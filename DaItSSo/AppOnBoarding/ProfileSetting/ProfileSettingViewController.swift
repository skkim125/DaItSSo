//
//  ProfileSettingViewController.swift
//  DaItSSo
//
//  Created by 김상규 on 6/13/24.
//

import UIKit
import SnapKit

final class ProfileSettingViewController: BaseViewController {
    
    private let setProfileImgButton = ProfileButton(profileImgType: .isSelected)
    private let profileImgView = UIImageView()
    private let setProfileImgSubButton = ProfileSubButton()
    private lazy var nicknameTextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.placeholder = "닉네임을 입력해주세요"
        tf.addTarget(self, action: #selector(nicknameTextFieldTextChanged), for: .editingChanged)
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        
        return tf
    }()
    private let dividerLine = DividerLine(color: .appLightGray)
    private let checkNicknameLabel = {
        let label = UILabel()
        label.textColor = .appMainColor
        label.font = .systemFont(ofSize: 13)
        
        return label
    }()
    private let loginButton = PointButton(title: "완료")
    
    private let userDefaults = UserDefaultsManager.shared
    private let errorManager = ErrorManager.shared
    private let profileList = ProfileImg.allCases
    
    var beforeVC: BaseViewController?
    var viewModel = ProfileViewModel()
    var navTitle = SetNavigationTitle.firstProfile
    
    override func configureNavigationBar() {
        navigationItem.title = navTitle.navTitle
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.backButtonImg, style: .plain, target: self, action: #selector(backButtonClicked))
        navigationController?.navigationBar.tintColor = .appBlack
        
        if beforeVC is SettingViewController {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonClicked))
        }
    }
    
    @objc private func backButtonClicked() {
        guard beforeVC is SettingViewController else {
            nicknameTextField.text = nil
            checkNicknameLabel.text = nil
            loginButton.isEnabled = false
            viewModel.outputProfileImg.value = nil
         
            navigationController?.popViewController(animated: true)
            return
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonClicked() {
        guard let nickname = viewModel.outputNickname.value, let editProfileImg = viewModel.outputProfileImg.value else { return }
        userDefaults.nickname = nickname
        userDefaults.profile = editProfileImg
        
        navigationController?.popViewController(animated: true)
    }
    
    func bindData() {
        
        viewModel.outputValidText.bind { str in
            self.checkNicknameLabel.text =  self.viewModel.outputValidText.value
        }
        
        viewModel.outputButtonEnabled.bind { isEnabled in
            if let isEnabled = isEnabled {
                self.setButtonUI(isValid: isEnabled)
            }
        }
        
        viewModel.outputProfileImg.bind { image in
            if let img = image {
                self.profileImgView.image = UIImage(named: img)
            }
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(setProfileImgButton)
        setProfileImgButton.addSubview(profileImgView)
        view.addSubview(setProfileImgSubButton)
        view.addSubview(nicknameTextField)
        view.addSubview(dividerLine)
        view.addSubview(checkNicknameLabel)
        view.addSubview(loginButton)
    }
    
    override func configureLayout() {
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
    
    override func configureView() {
        if beforeVC is SettingViewController {
            viewModel.outputProfileImg.value = userDefaults.profile
            viewModel.inputNickname.value = userDefaults.nickname
            nicknameTextField.text = viewModel.inputNickname.value
            loginButton.isHidden = true
        } else {
            viewModel.outputProfileImg.value = ProfileImg.allCases.randomElement()!.rawValue
            loginButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
            loginButton.configuration?.baseBackgroundColor = .appLightGray
        }
        
        setProfileImgButton.addTarget(self, action: #selector(setProfileImgButtonClicked), for: .touchUpInside)
        setProfileImgSubButton.addTarget(self, action: #selector(setProfileImgButtonClicked), for: .touchUpInside)
        
        bindData()
    }
    
    @objc private func setProfileImgButtonClicked() {
        let vc = SelectProfileImgViewController()
        vc.viewModel = self.viewModel
        vc.navTitle = self.navTitle
        if beforeVC is SettingViewController {
            vc.navTitle = self.navTitle
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func logIn() {
        guard let nickname = viewModel.outputNickname.value, let profileImg = viewModel.outputProfileImg.value else { return }
        userDefaults.saveUserInfo(nickname: nickname, profile: profileImg)
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let vc = TabViewController()
        
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    @objc func nicknameTextFieldTextChanged() {
        viewModel.inputNickname.value = nicknameTextField.text
    }
}

extension ProfileSettingViewController {
    private func setButtonUI(isValid: Bool) {
        if beforeVC is SettingViewController {
            
            navigationItem.rightBarButtonItem?.isEnabled = isValid
        } else {
            loginButton.isEnabled = isValid
            loginButton.configuration?.baseBackgroundColor = isValid ? .appMainColor : .appLightGray
        }
    }
}
