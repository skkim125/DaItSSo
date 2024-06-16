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
    
    let profileList = ProfileImg.allCases
    let userDefaults = UserDefaultsManager.shared
    var navTitle = SetNavigationTitle.firstProfile
    var profileImg: String = ""
    var editProfileImg: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        setUI()
        keyboardDismiss()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = navTitle.navTitle
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationController?.navigationBar.tintColor = UIColor.appBlack
        
        switch navTitle {
        case .firstProfile:
            break
        case .editProfile:
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonClicked))
        default:
            break
        }
    }
    
    @objc private func saveButtonClicked() {
        UserDefaultsManager.shared.profile = editProfileImg
        userDefaults.nickname = nicknameTextField.text!
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func backButtonTapped() {
        switch navTitle{
        case .firstProfile:
            UserDefaultsManager.shared.profile = ""
        case .editProfile:
            UserDefaultsManager.shared.profile = profileImg
            UserDefaultsManager.shared.editProfile = profileImg
        default:
            break
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
        
        switch navTitle{
        case .firstProfile:
            loginButton.addTarget(self, action: #selector(moveMainView), for: .touchUpInside)
            loginButton.isEnabled = false
            loginButton.backgroundColor = .appLightGray
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
        default:
            break
        }
        keyboardDismiss()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func moveMainView() {
        
        UserDefaultsManager.shared.isStart = true
        UserDefaultsManager.shared.nickname = nicknameTextField.text!
        UserDefaultsManager.shared.profile = profileImg
        UserDefaultsManager.shared.editProfile = profileImg
        UserDefaultsManager.shared.loginDate = DateFormatter.customDateFormatter(date: Date())
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
            switch navTitle{
            case .firstProfile:
                profileImg = userDefaults.profile
                profileImgView.image = UIImage(named: profileImg)
                nicknameTextField.text = nil
                checkNicknameLabel.text = nil
                loginButton.isEnabled = false
                loginButton.backgroundColor = .appLightGray
            case .editProfile:
                editProfileImg = userDefaults.editProfile
                profileImgView.image = UIImage(named: editProfileImg)
                
                nicknameTextField.text = userDefaults.nickname
                checkNicknameLabel.text = CheckNickname.ok.checkNicknameLabelText
            default:
                break
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        switch navTitle{
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
            checkNickname(nickName: text)
        }
    }
}

extension ProfileSettingViewController {
    
    func checkNickname(nickName: String) {
        guard nickName.count >= 2 && nickName.count < 10 else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .appLightGray
            checkNicknameLabel.text = CheckNickname.outRange.checkNicknameLabelText
            
            return
        }
        
        for i in nickName {
            guard Int(String(i)) == nil else {
                loginButton.isEnabled = false
                loginButton.backgroundColor = .appLightGray
                checkNicknameLabel.text = CheckNickname.noNumber.checkNicknameLabelText
                
                return
            }
        }
        
        for i in String.specialStringArray {
            guard !nickName.contains(i) else {
                loginButton.isEnabled = false
                loginButton.backgroundColor = .appLightGray
                checkNicknameLabel.text = CheckNickname.specialString(i).checkNicknameLabelText
                
                return
            }
        }
        
        loginButton.isEnabled = true
        loginButton.backgroundColor = .appMainColor
        checkNicknameLabel.text = CheckNickname.ok.checkNicknameLabelText
    }
    
}

extension String {
    static var specialStringArray = ["@", "#", "$", "%"]
}

extension DateFormatter {
    static func customDateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        let convertDate = dateFormatter.string(from: date)
        
        return ""
    }
}
