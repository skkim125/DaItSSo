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
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        
        return tf
    }()
    
    private lazy var dividerLine = DividerLine(color: .appLightGray)
    
    private lazy var checkNicknameLabel = {
        let label = UILabel()
        label.textColor = .appMainColor
        label.font = .systemFont(ofSize: 13)
        
        return label
    }()
    
    private lazy var loginButton = PointButton(title: "완료")
    
    private let userDefaults = UserDefaultsManager.shared
    private let errorManager = ErrorManager.shared
    private let profileList = ProfileImg.allCases
    var navTitle = SetNavigationTitle.firstProfile
    var profileImg: String = ""
    var editProfileImg: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appWhite
        
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        configureProfileSettingView()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = navTitle.navTitle
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.backButtonImg, style: .plain, target: self, action: #selector(backButtonClicked))
        navigationController?.navigationBar.tintColor = .appBlack
        
        switch navTitle {
        case .editProfile:
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonClicked))
        default:
            break
        }
    }
    
    @objc private func backButtonClicked() {
        switch navTitle{
        case .firstProfile:
            nicknameTextField.text = nil
            checkNicknameLabel.text = nil
            loginButton.isEnabled = false
            userDefaults.profile = ""
        case .editProfile:
            userDefaults.profile = profileImg
            userDefaults.editProfile = profileImg
        default:
            break
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonClicked() {
        userDefaults.profile = editProfileImg
        userDefaults.nickname = nicknameTextField.text!
        navigationController?.popViewController(animated: true)
    }
    
    private func configureHierarchy() {
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
    
    private func configureProfileSettingView() {
        profileImgView.image = UIImage(named: profileImg)
        setProfileImgButton.addTarget(self, action: #selector(setProfileImgButtonClicked), for: .touchUpInside)
        setProfileImgSubButton.addTarget(self, action: #selector(setProfileImgButtonClicked), for: .touchUpInside)
        
        switch navTitle{
        case .firstProfile:
            loginButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
            loginButton.configuration?.baseBackgroundColor = .appLightGray
        case .editProfile:
            loginButton.isHidden = true
        default:
            break
        }
    }
    
    @objc private func setProfileImgButtonClicked() {
        let vc = SelectProfileImgViewController()
        vc.navTitle = self.navTitle
        switch navTitle{
        case .firstProfile:
            vc.selectedProfile = profileImg
        case .editProfile:
            vc.selectedProfile = editProfileImg
            vc.navTitle = self.navTitle
        default:
            break
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func logIn() {
        
        userDefaults.saveUserInfo(nickname: nicknameTextField.text!, profile: profileImg, editProfile: profileImg)
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let vc = TabViewController()
        
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if profileImg.isEmpty {
            profileImg = ProfileImg.allCases.randomElement()!.rawValue
            profileImgView.image = UIImage(named: profileImg)
        } else {
            switch navTitle {
            case .firstProfile:
                profileImg = userDefaults.profile
                profileImgView.image = UIImage(named: profileImg)
                if !nicknameTextField.text!.isEmpty {
                    checkNickname(nickname: nicknameTextField.text!)
                }
            case .editProfile:
                editProfileImg = userDefaults.editProfile
                profileImgView.image = UIImage(named: editProfileImg)
            default:
                break
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        switch navTitle {
        case .firstProfile:
            break
        case .editProfile:
            editProfileImg = userDefaults.profile
        default:
            break
        }
    }
}

extension ProfileSettingViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if let text = textField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty {
            checkNickname(nickname: text)
        }
    }
}

extension ProfileSettingViewController {
    
    func checkNickname(nickname: String) {
        do {
            try errorManager.checkNicknameCondition(nickname: nickname)
            setbuttonEnabled(navTitle: navTitle)
        } catch let error as ErrorType.CheckNickname {
            setButtonDisable(navTitle: navTitle)
            checkNicknameLabel.text = error.checkNicknameLabelText
        } catch {
            print(error)
        }
    }
    
    func setButtonDisable(navTitle: SetNavigationTitle) {
        switch navTitle {
        case .firstProfile:
            loginButton.isEnabled = false
            loginButton.configuration?.baseBackgroundColor = .appLightGray
        case .editProfile:
            navigationItem.rightBarButtonItem?.isEnabled = false
        default:
            break
        }
    }
    
    func setbuttonEnabled(navTitle: SetNavigationTitle) {
        switch navTitle {
        case .firstProfile:
            loginButton.isEnabled = true
            loginButton.configuration?.baseBackgroundColor = .appMainColor
        case .editProfile:
            navigationItem.rightBarButtonItem?.isEnabled = true
        default:
            break
        }
        checkNicknameLabel.text = ErrorType.CheckNickname.ok.checkNicknameLabelText
    }
}
