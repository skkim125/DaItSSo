//
//  SearchResultDetailViewController.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit
import SnapKit
import WebKit
import Reachability

final class SearchResultDetailViewController: BaseViewController {
    private let webView = WKWebView()
    private let msr = MyShoppingRepository()
    private let reachability: Reachability = try! Reachability()
    var image: UIImage?
    var shopping: MyShopping?
    var searchText = ""
    var isAdd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkReachability()
        configureRightBarButtonUI()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = SetNavigationTitle.search(searchText).navTitle
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.backButtonImg, style: .plain, target: self, action: #selector(backButtonClicked))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "handbag.fill"), style: .plain, target: self, action: #selector(selectProductButtonClicked))
    }
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func selectProductButtonClicked() {
        isAdd.toggle()
        if let i = shopping {
            if isAdd {
                
                let newShopping = MyShopping(value: i)
                msr.addMyShopping(newShopping)
                if let image = self.image {
                    ImageManager.shared.saveImageToDocument(image: image, filename: i.productId)
                }
            } else {
                switch msr.loadMyShopping().isEmpty {
                case true:
                    let filterdShopping = msr.loadMyShopping().filter { $0.productId == i.productId }
                    if let lastIndex = msr.loadMyShopping().lastIndex(where: {
                        $0.productId == filterdShopping[filterdShopping.startIndex].productId
                    }) {
                        ImageManager.shared.removeImageFromDocument(filename: i.productId)
                        msr.deleteMyShopping(msr.loadMyShopping()[lastIndex])
                    }
                case false:
                    if let lastIndex = msr.loadMyShopping().lastIndex(where: {
                        $0.productId == i.productId
                    }) {
                        ImageManager.shared.removeImageFromDocument(filename: i.productId)
                        msr.deleteMyShopping(msr.loadMyShopping()[lastIndex])
                    }
                }
            }
        }

        configureRightBarButtonUI()
    }
    
    private func configureRightBarButtonUI() {
        navigationItem.rightBarButtonItem?.image = isAdd ? UIImage(systemName: "handbag.fill") : UIImage(systemName: "handbag")
        navigationItem.rightBarButtonItem?.tintColor = .appBlack
    }
    
    override func configureHierarchy() {
        view.addSubview(webView)
    }
    
    override func configureLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureWebViewUI(link: String) {
        guard let url = URL(string: link) else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    private func networkReachability() {
        do {
            try reachability.startNotifier()
            print("네트워크 연결 정상")
        } catch {
            print("Unable to start notifier")
        }
        
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.presentErrorAlert(searchError: .networkError) { _ in
            }
        }
    }
}
