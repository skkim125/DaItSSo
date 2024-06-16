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
    
    var myShopping = Item(title: "", image: "", mallName: "", lprice: "", link: "", productId: "")
    var item: Item?
    var searchText = ""
    var isAdd = false
    lazy var navTitle = SetNavigationTitle.search(searchText)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
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
    
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func selectProductButtonClicked() {
        isAdd.toggle()
        if let i = item {
            if UserDefaultsManager.shared.myShopping.isEmpty {
                let filterdShopping = UserDefaultsManager.shared.myShopping.filter { $0.productId == i.productId }
                if isAdd {
                    UserDefaultsManager.shared.myShopping.append(i)
                } else {
                    UserDefaultsManager.shared.myShopping.remove(at: UserDefaultsManager.shared.myShopping.lastIndex(where: {
                        $0.productId == filterdShopping[filterdShopping.startIndex].productId
                    })!)
                }
            } else {
                if isAdd {
                    UserDefaultsManager.shared.myShopping.append(i)
                } else {
                    UserDefaultsManager.shared.myShopping.remove(at: UserDefaultsManager.shared.myShopping.lastIndex(where: {
                        $0.productId == i.productId
                    })!)
                }
            }
        }

        configureRightBarButtonUI()
    }
    
    func configureRightBarButtonUI() {
        if isAdd {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "handbag.fill")
            navigationItem.rightBarButtonItem?.tintColor = .black
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "handbag")
            navigationItem.rightBarButtonItem?.tintColor = .black
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
