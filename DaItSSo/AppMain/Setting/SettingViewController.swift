//
//  SettingViewController.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit

class SettingViewController: BaseViewController {
    private lazy var settingTableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(MyProfileTableViewCell.self, forCellReuseIdentifier: MyProfileTableViewCell.id)
        tv.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.id)
        tv.separatorColor = .appBlack
        tv.separatorStyle = .singleLine
        tv.separatorInset = .zero
        tv.isScrollEnabled = false
        
        return tv
    }()
    
    private let userDefaults = UserDefaultsManager.shared
    private var profileImg = ""
    
    override func configureNavigationBar() {
        navigationItem.title = SetNavigationTitle.setting.navTitle
    }
    
    override func configureHierarchy() {
        view.addSubview(settingTableView)
    }
    
    override func configureLayout() {
        
        settingTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profileImg = userDefaults.profile
        settingTableView.reloadData()
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Setting.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch Setting.allCases[indexPath.row] {
        case .myProfile:
            return 120
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = Setting.allCases[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.id) as? SettingTableViewCell else { return UITableViewCell() }
        
        cell.configureSettingLabel(title: setting.rawValue)
        cell.selectionStyle = .none
        
        switch setting {
        case .myProfile:
            if let myProfileCell = tableView.dequeueReusableCell(withIdentifier: MyProfileTableViewCell.id) as? MyProfileTableViewCell {
                myProfileCell.configureMyProfileCellUI(image: profileImg, nickName: userDefaults.nickname, date: userDefaults.loginDate)
                
                return myProfileCell
            }
            
        case .myShopping:
            cell.configureMyShoppingCellHierarchy()
            cell.configureMyShoppingCellLayout()
            cell.configureMyShoppingCellUI(count: userDefaults.myShopping.count)
            cell.showLabel(bool: false)
            
            return cell
            
        default:
            cell.showLabel(bool: true)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = Setting.allCases[indexPath.row]
        
        switch setting {
        case .myProfile:
            let vc = ProfileSettingViewController()
            vc.navTitle = .editProfile
            vc.profileImg = self.profileImg
            vc.nicknameTextField.text = userDefaults.nickname
            navigationController?.pushViewController(vc, animated: true)
            navigationItem.rightBarButtonItem?.action = #selector(saveButtonClicked)
            
        case .deleteId:
            presentTwoActionsAlert(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 초기화됩니다. 탈퇴하시겠습니까?", act: "탈퇴") { _ in
                self.userDefaults.removeValue(keys: UserDefaultsManager.Key.allCases)
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let vc = OnBoardingViewController()
                let nav = UINavigationController(rootViewController: vc)
                
                sceneDelegate?.window?.rootViewController = nav
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            
        default:
            break
        }
    }
    
    @objc func saveButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}
