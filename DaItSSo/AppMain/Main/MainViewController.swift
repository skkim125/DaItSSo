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
    
    private lazy var searchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "브랜드, 상품 등을 입력하세요"
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        
        return searchBar
    }()
    
    private lazy var dividerLine = DividerLine(color: .appLightGray)
    
    private lazy var stackView = {
        let view = UIView()
        view.addSubview(recentSearchLabel)
        view.addSubview(removeAllButton)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.keyboardDismiss)))
        
        return view
    }()
    
    private lazy var recentSearchLabel = {
        let label = UILabel()
        label.text = "최근 검색"
        label.textColor = .appBlack
        label.font = .boldSystemFont(ofSize: 15)
        
        return label
    }()
    
    private lazy var removeAllButton = {
        let button = UIButton(type: .system)
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(.appMainColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(removeAllButtonClicked), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func removeAllButtonClicked() {
        let alert = UIAlertController(title: "정말로 전체 삭제하시겠습니까?", message: "최근 검색어 목록이 모두 삭제됩니다.", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        let removeAll = UIAlertAction(title: "전체 삭제", style: .destructive) { _ in
            self.userDefaults.recentSearchList.removeAll()
            self.showView()
            self.recentSearchTableView.reloadData()
        }
        
        alert.addAction(cancel)
        alert.addAction(removeAll)
        
        present(alert, animated: true)
    }
    
    private lazy var noRecentSearchView = {
        let view = UIView()
        view.backgroundColor = .appWhite
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    private lazy var emptyImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "empty")
        imgView.contentMode = .scaleAspectFit
        
        return imgView
    }()
    
    private lazy var emptyLabel = {
        let label = UILabel()
        label.text = "최근 검색어가 없어요"
        label.textColor = .appBlack
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var recentSearchTableView = {
        let tv = UITableView()
        tv.backgroundColor = .appWhite
        tv.delegate = self
        tv.dataSource = self
        tv.register(RecentSearchTableViewCell.self, forCellReuseIdentifier: RecentSearchTableViewCell.id)
        tv.rowHeight = 40
        tv.separatorStyle = .none
        
        return tv
    }()
    
    private let userDefaults = UserDefaultsManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appWhite
        configureHierarchy()
        configureLayout()
        configureNavigationbar()
        showView()
    }
    
    private func configureNavigationbar() {
        let navTitle = SetNavigationTitle.main(userDefaults.nickname)
        navigationItem.title = navTitle.navTitle
    }
    
    private func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(dividerLine)
        view.addSubview(stackView)
        view.addSubview(noRecentSearchView)
        view.addSubview(recentSearchTableView)
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
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
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
        
        recentSearchLabel.snp.makeConstraints { make in
            make.leading.equalTo(stackView.snp.leading).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(stackView)
        }
        
        removeAllButton.snp.makeConstraints { make in
            make.trailing.equalTo(stackView.snp.trailing).inset(20)
            make.size.equalTo(recentSearchLabel)
        }
        
        recentSearchTableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationbar()
        showView()
        recentSearchTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardDismiss()
        searchBar.text = nil
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDefaults.recentSearchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.id, for: indexPath) as! RecentSearchTableViewCell
        let data = userDefaults.recentSearchList[indexPath.row]
        cell.configureCellUI(search: data)
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonClicked(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func deleteButtonClicked(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: recentSearchTableView)
        guard let indexPath = recentSearchTableView.indexPathForRow(at: point) else { return }
        userDefaults.recentSearchList.remove(at: indexPath.row)
        recentSearchTableView.deleteRows(at: [indexPath], with: .none)
        recentSearchTableView.reloadData()
        
        if userDefaults.recentSearchList.isEmpty {
            showView()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RecentSearchTableViewCell
        
        if let text = cell.recentSearchLabel.text {
            let results = userDefaults.recentSearchList.filter { $0 == text }
            saveRecentSearch(results: results, text: text)
            
            let vc = SearchResultViewController()
            vc.searchText = text
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            let results = userDefaults.recentSearchList.filter { $0 == text }
            saveRecentSearch(results: results, text: text)
            
            let vc = SearchResultViewController()
            vc.searchText = text
            keyboardDismiss()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
    }
}

extension MainViewController {
    
    private func showView() {
        if userDefaults.recentSearchList.isEmpty {
            noRecentSearchView.isHidden = false
            stackView.isHidden = true
            recentSearchTableView.isHidden = true
        } else {
            noRecentSearchView.isHidden = true
            stackView.isHidden = false
            recentSearchTableView.isHidden = false
        }
    }
    
    func saveRecentSearch(results: [String], text: String) {
        if results.isEmpty {
            userDefaults.recentSearchList.insert(text, at: 0)
        } else {
            userDefaults.recentSearchList.remove(at: userDefaults.recentSearchList.lastIndex(where: { $0 == results.first ?? "" })!)
            userDefaults.recentSearchList.insert(text, at: 0)
        }
    }
}
