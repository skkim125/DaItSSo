//
//  MainViewController.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit
import SnapKit
import Alamofire

class MainViewController: UIViewController {
    
    lazy var searchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "브랜드, 상품 등을 입력하세요"
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var dividerLine = DividerLine(color: UIColor.appLightGray)
    
    lazy var noRecentSearchView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
        
        return view
    }()
    
    lazy var emptyImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "empty")
        imgView.contentMode = .scaleAspectFit
        
        return imgView
    }()
    
    lazy var emptyLabel = {
        let label = UILabel()
        label.text = "최근 검색어가 없어요"
        label.textColor = .appBlack
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var recentSearchTableView = {
        let tv = UITableView()
        tv.backgroundColor = .appMainColor
        
        return tv
    }()
    
    var recentSearchArray: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureHierarchy()
        configureLayout()
        configureNavigationbar()
        showView()
    }
    
    func configureNavigationbar() {
        navigationItem.title = "닉네임's DaItSSo"
    }
    
    func configureHierarchy() {
        // MARK: addSubView()
        view.addSubview(searchBar)
        view.addSubview(dividerLine)
        view.addSubview(noRecentSearchView)
        view.addSubview(recentSearchTableView)
    }
    
    func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        
        dividerLine.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        noRecentSearchView.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.top.equalTo(noRecentSearchView.snp.top).offset(30)
            make.horizontalEdges.equalTo(noRecentSearchView)
            make.height.equalTo(emptyImageView.snp.width)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom)
            make.horizontalEdges.equalTo(emptyImageView)
            make.height.equalTo(30)
        }
        
        recentSearchTableView.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func showView() {
        if recentSearchArray.isEmpty {
            noRecentSearchView.isHidden = false
            recentSearchTableView.isHidden = true
        }  else {
            noRecentSearchView.isHidden = true
            recentSearchTableView.isHidden = false
        }
    }
    
}

//extension MainViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//    
//}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        guard let text = searchBar.text else {
            return
        }
        recentSearchArray.append(text)
        print(recentSearchArray)
        
        let vc = SearchResultViewController()
        vc.searchText = text
        vc.selectedSortButtonUI(button: vc.simSortButton)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
    }
}
