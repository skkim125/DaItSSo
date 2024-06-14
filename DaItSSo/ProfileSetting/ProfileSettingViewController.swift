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
    
    private lazy var nicknameTextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.placeholder = "닉네임을 입력해주세요"
        tf.delegate = self
        
        return tf
    }()
    
    private lazy var dividerLine = {
        let view = UIView()
        view.backgroundColor = .appLightGray
        
        return view
    }()
    
    private lazy var checkNicknameLabel = {
        let label = UILabel()
        label.textColor = .appMainColor
        label.font = .systemFont(ofSize: 13)
        
        return label
    }()
    
    private lazy var loginButton = PointButton(title: "완료")
    
    private var profileImg: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
        setUI()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Profile Setting"
        navigationController?.navigationBar.isHidden = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationController?.navigationBar.tintColor = UIColor.appBlack
    }
    
    @objc private func backButtonTapped() {
        UserDefaultsManager.shared.userdefaults.removeObject(forKey: "profile")
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
        loginButton.addTarget(self, action: #selector(moveMainView), for: .touchUpInside)
        loginButton.isEnabled = false
        loginButton.backgroundColor = .appLightGray

    }
    
    @objc private func setProfileImgButtonClicked() {
        print(#function)
        let vc = SelectProfileImgViewController()
        vc.selectedProfile = profileImg
        navigationController?.pushViewController(vc, animated: true)
        print(vc.selectedProfile)
    }
    
    @objc private func moveMainView() {
        print(#function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setProfileImgButton.layer.cornerRadius = setProfileImgButton.frame.width / 2
        setProfileImgSubButton.layer.cornerRadius = setProfileImgSubButton.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let img = UserDefaultsManager.shared.userdefaults.string(forKey: "profile") == nil ? UIImage.profileImgArray.randomElement()! : UserDefaultsManager.shared.userdefaults.string(forKey: "profile")!
        profileImg = img
        profileImgView.image = UIImage(named: img)
        print(UserDefaultsManager.shared.userdefaults.string(forKey: "profile"), img)
        
        nicknameTextField.text = nil
        checkNicknameLabel.text = nil
        loginButton.isEnabled = false
        loginButton.backgroundColor = .appLightGray
    }
}

extension ProfileSettingViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty {
            print(#function, text)
            
            guard text.count >= 2 && text.count < 10 else {
                loginButton.isEnabled = false
                loginButton.backgroundColor = .appLightGray
                checkNicknameLabel.text = "2글자 이상 10글자 미만으로 설정해주세요"
                
                return true
            }
            
            for i in text {
                guard Int(String(i)) == nil else {
                    loginButton.isEnabled = false
                    loginButton.backgroundColor = .appLightGray
                    checkNicknameLabel.text = "닉네임에 숫자는 포함할 수 없어요"
                    return true
                }
            }
            
            let specialStringArr = ["@", "#", "$", "%"]
            
            for i in specialStringArr {
                guard !text.hasPrefix(i) else {
                    loginButton.isEnabled = false
                    loginButton.backgroundColor = .appLightGray
                    checkNicknameLabel.text = "닉네임에 \(i)는 포함할 수 없어요"
                    return true
                }
            }
            
            loginButton.isEnabled = true
            loginButton.backgroundColor = .appMainColor
            checkNicknameLabel.text = "사용할 수 있는 닉네임이에요!"
            
            return true
        }
        
        return true
    }
    
    
}
