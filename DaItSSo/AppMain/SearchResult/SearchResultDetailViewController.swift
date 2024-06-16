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
    
    var myShopping = MyShopping(item: Item(title: "", image: "", mallName: "", lprice: "", link: "", productId: ""), addDate: Date(), save: false)
    var item: Item?
    var vmMyShopping: [MyShopping] = []
    var searchText = ""
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
        self.myShopping.save.toggle()
        configureRightBarButtonUI()
    }
    
    func configureRightBarButtonUI() {
        
        if let i = item {
            // var myShopping = MyShopping(item: i, addDate: Date(), save: isShopping)
            if myShopping.save {
                myShopping = MyShopping(item: i, addDate: Date(), save: myShopping.save)
                UserDefaultsManager.shared.myShopping.append(myShopping)
            } else {
                let filterd = vmMyShopping.filter { $0.item.productId != myShopping.item.productId }
                UserDefaultsManager.shared.myShopping = filterd
            }
        }
        
        if myShopping.save {
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
