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
    private lazy var webView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        
        return webView
    }()
    
    private let userDefaults = UserDefaultsManager.shared
    lazy var navTitle = SetNavigationTitle.search(searchText)
    var item: Item?
    var searchText = ""
    var isAdd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appWhite
        
        configureHierarchy()
        configureLayout()
        configureNavigationBar()
        configureRightBarButtonUI()
        
    }
    
    func configureNavigationBar() {
        navigationItem.title = navTitle.navTitle
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.backButtonImg, style: .plain, target: self, action: #selector(backButtonClicked))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "handbag.fill"), style: .plain, target: self, action: #selector(selectProductButtonClicked))
    }
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func selectProductButtonClicked() {
        isAdd.toggle()
        if let i = item {
            switch userDefaults.myShopping.isEmpty {
            case true:
                let filterdShopping = userDefaults.myShopping.filter { $0.productId == i.productId }
                if isAdd {
                    userDefaults.myShopping.append(i)
                } else {
                    userDefaults.myShopping.remove(at: userDefaults.myShopping.lastIndex(where: {
                        $0.productId == filterdShopping[filterdShopping.startIndex].productId
                    })!)
                }
            case false:
                if isAdd {
                    userDefaults.myShopping.append(i)
                } else {
                    userDefaults.myShopping.remove(at: userDefaults.myShopping.lastIndex(where: {
                        $0.productId == i.productId
                    })!)
                }
            }
        }

        configureRightBarButtonUI()
    }
    
    private func configureRightBarButtonUI() {
        if isAdd {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "handbag.fill")
            navigationItem.rightBarButtonItem?.tintColor = .appBlack
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "handbag")
            navigationItem.rightBarButtonItem?.tintColor = .appBlack
        }
    }
    
    private func configureHierarchy() {
        view.addSubview(webView)
    }
    
    private func configureLayout() {
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

extension SearchResultDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        presentBackAlert(searchError: .networkError)
        print(#function)
    }
}
