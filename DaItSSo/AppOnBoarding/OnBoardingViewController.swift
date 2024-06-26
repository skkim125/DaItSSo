//
//  OnBoardingViewController.swift
//  DaItSSo
//
//  Created by 김상규 on 6/13/24.
//

import UIKit

class OnBoardingViewController: BaseViewController {
    
    private let appNameLabel = {
        let label = UILabel()
        label.text = "DaItSSo"
        label.textColor = .appMainColor
        label.font = UIFont(name: "Chalkboard SE Regular", size: 50)
        label.textAlignment = .center
        
        return label
    }()
    
    private let appImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "launch")
        imgView.contentMode = .scaleAspectFill
        
        return imgView
    }()
    
    private let startButton = PointButton(title: "Start")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureStartButton()
    }
    
    override func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func configureStartButton() {
        startButton.addTarget(self, action: #selector(goLoginView), for: .touchUpInside)
    }
    
    @objc private func goLoginView() {
        let vc = ProfileSettingViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func configureHierarchy() {
        view.addSubview(appNameLabel)
        view.addSubview(appImageView)
        view.addSubview(startButton)
    }
    
    override func configureLayout() {
        appNameLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(60)
        }
        
        appImageView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.top.equalTo(appNameLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(appNameLabel)
            make.height.equalTo(appImageView.snp.width)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(appNameLabel)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
    }
}
