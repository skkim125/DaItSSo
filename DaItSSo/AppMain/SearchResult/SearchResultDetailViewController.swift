//
//  SearchResultDetailViewController.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit
import SnapKit
import WebKit

class SearchResultDetailViewController: UIViewController {
    lazy var webView = {
        let webView = WKWebView()
        
        return webView
    }()
    
    var isShopping: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureHierarchy()
        configureLayout()
        configureNavigationBar()
        configureRightBarButtonUI()
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.backButtonImg, style: .plain, target: self, action: #selector(backButtonClicked))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "handbag.fill"), style: .plain, target: self, action: #selector(selectProductButtonClicked))
    }
    
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func selectProductButtonClicked() {
        self.isShopping?.toggle()
        configureRightBarButtonUI()
    }
    
    func configureRightBarButtonUI() {
        if let bool = isShopping {
            if bool {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "handbag.fill")
                navigationItem.rightBarButtonItem?.tintColor = .black
            } else {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "handbag")
                navigationItem.rightBarButtonItem?.tintColor = .black
            }
        }
    }
    
    func configureHierarchy() {
        view.addSubview(webView)
    }
    
    func configureLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureWebViewUI(link: String) {
        let url = URL(string: link)!
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
}
