//
//  SearchResultViewController.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit

class SearchResultViewController: UIViewController {
    
    lazy var resultCollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.prefetchDataSource = self
        cv.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.id)
        
        return cv
    }()
    
    lazy var totalResultLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        label.textColor = .appMainColor
        
        return label
    }()
    
    lazy var simSortButton = SortButton(sortType: .sim)
    lazy var dateSortButton = SortButton(sortType: .date)
    lazy var dscSortButton = SortButton(sortType: .dsc)
    lazy var ascSortButton = SortButton(sortType: .asc)
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let sectionSpacing: CGFloat = 20
        let cellSpacing: CGFloat = 20
        let width = UIScreen.main.bounds.width-(sectionSpacing*2 + cellSpacing*1)
        
        layout.itemSize = CGSize(width: width/2, height: (width/2) * 1.8)
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = .init(top: 0, left: sectionSpacing, bottom: 0, right: sectionSpacing)
        layout.scrollDirection = .vertical
        
        return layout
    }
    
    private let userDefaults = UserDefaultsManager.shared
    var searchResults: [Item] = []
    var searchText: String = ""
    var sort: SortType = .sim
    var start = 1
    lazy var navTitle = SetNavigationTitle.search(searchText)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .appWhite
        configureNavigationBar()
        callRequest(keyword: searchText, sort: SortType.sim)
        configureHierarchy()
        configureLayout()
        configureSortButtons()
    }
    
    func configureNavigationBar() {
        navigationItem.title = navTitle.navTitle
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        navigationController?.navigationBar.tintColor = .appDarkGray
    }
    
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureHierarchy() {
        view.addSubview(totalResultLabel)
        view.addSubview(simSortButton)
        view.addSubview(dateSortButton)
        view.addSubview(dscSortButton)
        view.addSubview(ascSortButton)
        view.addSubview(resultCollectionView)
    }
    
    private func configureLayout() {
        totalResultLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(30)
        }
        
        simSortButton.snp.makeConstraints { make in
            make.top.equalTo(totalResultLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(30)
        }
        
        dateSortButton.snp.makeConstraints { make in
            make.top.equalTo(simSortButton)
            make.leading.equalTo(simSortButton.snp.trailing).offset(10)
            make.height.equalTo(simSortButton)
        }
        
        dscSortButton.snp.makeConstraints { make in
            make.top.equalTo(simSortButton)
            make.leading.equalTo(dateSortButton.snp.trailing).offset(10)
            make.height.equalTo(simSortButton)
        }
        
        ascSortButton.snp.makeConstraints { make in
            make.top.equalTo(simSortButton)
            make.leading.equalTo(dscSortButton.snp.trailing).offset(10)
            make.height.equalTo(simSortButton)
        }
        
        resultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(simSortButton.snp.bottom).offset(15)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func callRequest(keyword: String, sort: SortType) {
        let url = "https://openapi.naver.com/v1/search/shop.json"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.clientId,
            "X-Naver-Client-Secret": APIKey.key
        ]
        
        let param: Parameters = [
            "query": "\(keyword)",
            "start": "\(start)",
            "display": "30",
            "sort": "\(sort.rawValue)",
        ]
        
        AF.request(url, method: .get, parameters: param, headers: header).responseDecodable(of: Shopping.self) { response in
            switch response.result {
            case .success(let value):
                
                if self.start == 1 {
                    self.searchResults = value.items
                } else {
                    self.searchResults.append(contentsOf: value.items)
                }
                
                self.totalResultLabel.text = value.total == 0 ? "검색 결과가 없습니다" : "\(value.total)개의 검색결과"
                self.resultCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
                self.totalResultLabel.text = "네트워크를 확인해주세요"
            }
        }
    }
    
    func configureSortButtons() {
        simSortButton.configuration?.baseForegroundColor = .appWhite
        simSortButton.configuration?.baseBackgroundColor = .appDarkGray
        
        simSortButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
        dateSortButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
        dscSortButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
        ascSortButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
    }
    
    @objc func sortButtonClicked(_ sender: UIButton) {
        sortButtonAction(button: sender)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resultCollectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        resultCollectionView.reloadData()
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as! SearchResultCollectionViewCell
        let data = searchResults[indexPath.item]
        
        cell.configureCellUI(item: data)
        cell.item = searchResults[indexPath.item]
        
        if userDefaults.myShopping.contains(where: { $0 == data }) {
            cell.isAdd = true
        } else {
            cell.isAdd = false
        }
        cell.configureSelectButtonUI()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedData = searchResults[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath) as! SearchResultCollectionViewCell
        
        let vc = SearchResultDetailViewController()
        vc.item = selectedData
        vc.isAdd = cell.isAdd
        vc.searchText = String.removeTag(title: selectedData.title)
        vc.configureWebViewUI(link: selectedData.link)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { i in
            if searchResults.count-8 == i.row {
                start += 30
                callRequest(keyword: searchText, sort: sort)
            }
        }
    }
}

extension SearchResultViewController {
    
    func sortButtonAction(button: UIButton) {
        switch button.tag {
        case 0:
            callRequest(keyword: searchText, sort: .sim)
            isSelectedSortButtonUI(button: button)
            
        case 1:
            callRequest(keyword: searchText, sort: .date)
            isSelectedSortButtonUI(button: button)
            
            return
        case 2:
            callRequest(keyword: searchText, sort: .dsc)
            isSelectedSortButtonUI(button: button)
            
            return
        case 3:
            callRequest(keyword: searchText, sort: .asc)
            isSelectedSortButtonUI(button: button)
            
            return
        default:
            break
        }
    }
    
    func isSelectedSortButtonUI(button: UIButton) {
        button.configuration?.baseForegroundColor = .appWhite
        button.configuration?.baseBackgroundColor = .appDarkGray
    }
    
    func unSelectedSortButtonUI(button: UIButton) {
        button.configuration?.baseForegroundColor = .appDarkGray
        button.configuration?.baseBackgroundColor = .appWhite
    }
}
