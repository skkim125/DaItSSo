//
//  OnBoardingViewController.swift
//  DaItSSo
//
//  Created by 김상규 on 6/13/24.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    let appNameLabel = {
        let label = UILabel()
        label.text = "DaItSo"
        label.textColor = UIColor.mainColor
        label.font = .systemFont(ofSize: 50, weight: .heavy)
        label.textAlignment = .center
        
        return label
    }()
    
    let appImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "launch")
        imgView.contentMode = .scaleAspectFill
        
        return imgView
    }()
    
    let startButton = PointButton(title: "시작하기")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        configureHierarchy()
        configureLayout()
        
        startButton.addTarget(self, action: #selector(goLoginView), for: .touchUpInside)
    }
    
    func configureHierarchy() {
        view.addSubview(appNameLabel)
        view.addSubview(appImageView)
        view.addSubview(startButton)
    }
    
    func configureLayout() {
        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(60)
        }
        
        appImageView.snp.makeConstraints { make in
            make.top.equalTo(appNameLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(appNameLabel)
            make.height.equalTo(appImageView.snp.width)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(appNameLabel)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(60)
        }
    }
    
    
    @objc func goLoginView() {
        let vc = ProfileSettingViewController()
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
