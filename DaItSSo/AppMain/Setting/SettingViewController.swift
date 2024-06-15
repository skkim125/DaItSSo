//
//  SettingViewController.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit

class SettingViewController: UIViewController {
    private lazy var settingTableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(MyProfileTableViewCell.self, forCellReuseIdentifier: MyProfileTableViewCell.id)
        tv.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.id)
        tv.separatorColor = .appBlack
        tv.separatorStyle = .singleLine
        tv.separatorInset = .zero
        
        return tv
    }()
    
    private var profileImg = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureNavigationBar()
        configureHierarchy()
        configureLayout()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "SETTING"
    }
    
    func configureHierarchy() {
        view.addSubview(settingTableView)
    }
    
    func configureLayout() {
        
        settingTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profileImg = UserDefaultsManager.shared.profile
        settingTableView.reloadData()
        print(UserDefaultsManager.shared.profile)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.id) as! SettingTableViewCell
        cell.configureSettingLabel(title: setting.rawValue)
        
        switch setting {
        case .myProfile:
            let myProfileCell = tableView.dequeueReusableCell(withIdentifier: MyProfileTableViewCell.id) as! MyProfileTableViewCell
            myProfileCell.configureMyProfileCellUI(image: profileImg)
            
            return myProfileCell
            
        case .myShopping:
            
            return cell
            
        default:
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = Setting.allCases[indexPath.row]
        
        switch setting {
        case .myProfile:
            let vc = ProfileSettingViewController()
            vc.profileViewType = .edit
            vc.profileImg = self.profileImg
            vc.nicknameTextField.text = UserDefaultsManager.shared.defaults.string(forKey: "nickname") ?? ""
            navigationController?.pushViewController(vc, animated: true)
            navigationItem.rightBarButtonItem?.action = #selector(saveButtonClicked)
            
        case .deleteId:
            let alert = UIAlertController(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 초기화됩니다. 탈퇴하시겠습니까?", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
                
                UserDefaultsManager.shared.removeValue(keys: UserDefaultsManager.Key.allCases)
                UserDefaultsManager.shared.isStart = false
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let vc = OnBoardingViewController()
                let nav = UINavigationController(rootViewController: vc)
                
                sceneDelegate?.window?.rootViewController = nav
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            
            alert.addAction(cancel)
            alert.addAction(delete)

            present(alert, animated: true)
        default:
            break
        }
    }
    
    @objc func saveButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}
