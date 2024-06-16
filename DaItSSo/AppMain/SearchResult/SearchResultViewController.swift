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
        label.textColor = UIColor.appMainColor
        
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
    
    var vmMyShopping: [MyShopping] = []
    var vmShopping: Shopping = Shopping(total: 0, items: [])
    var vcResults: [Item] = []
    var searchText: String = ""
    var sort: SortType = .sim
    var page = 1
    lazy var navTitle = SetNavigationTitle.search(searchText)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
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
    
    func configureHierarchy() {
        // MARK: addSubView()
        view.addSubview(totalResultLabel)
        view.addSubview(simSortButton)
        view.addSubview(dateSortButton)
        view.addSubview(dscSortButton)
        view.addSubview(ascSortButton)
        view.addSubview(resultCollectionView)
    }
    
    func configureLayout() {
        totalResultLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(30)
        }
        
        simSortButton.snp.makeConstraints { make in
            make.top.equalTo(totalResultLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(35)
            make.width.equalTo(simSortButton.snp.height).multipliedBy(1.5)
        }
        
        dateSortButton.snp.makeConstraints { make in
            make.top.equalTo(simSortButton)
            make.leading.equalTo(simSortButton.snp.trailing).offset(10)
            make.height.equalTo(simSortButton)
            make.width.equalTo(simSortButton.snp.height).multipliedBy(1.5)
        }
        
        dscSortButton.snp.makeConstraints { make in
            make.top.equalTo(simSortButton)
            make.leading.equalTo(dateSortButton.snp.trailing).offset(10)
            make.height.equalTo(simSortButton)
            make.width.equalTo(simSortButton.snp.height).multipliedBy(2)
        }
        
        ascSortButton.snp.makeConstraints { make in
            make.top.equalTo(simSortButton)
            make.leading.equalTo(dscSortButton.snp.trailing).offset(10)
            make.height.equalTo(simSortButton)
            make.width.equalTo(simSortButton.snp.height).multipliedBy(2)
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
            "start": "\(page)",
            "display": "30",
            "sort": "\(sort.rawValue)",
        
        ]
        
        AF.request(url, method: .get, parameters: param, headers: header).responseDecodable(of: Shopping.self) { response in
            switch response.result {
            case .success(let value):
                self.vmShopping = value
                
                if self.page == 1 {
                    self.vcResults = value.items
                } else {
                    self.vcResults.append(contentsOf: value.items)
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
        let simSortAction = UIAction { [self] _ in
            self.callRequest(keyword: searchText, sort: .sim)
            
            selectedSortButtonUI(button: simSortButton)
            unSelectedSortButtonUI(button: dateSortButton)
            unSelectedSortButtonUI(button: ascSortButton)
            unSelectedSortButtonUI(button: dscSortButton)
        }
        simSortButton.addAction(simSortAction, for: .touchUpInside)
        
        let dateSortAction = UIAction { [self] _ in
            self.callRequest(keyword: searchText, sort: .date)
            selectedSortButtonUI(button: dateSortButton)
            unSelectedSortButtonUI(button: simSortButton)
            unSelectedSortButtonUI(button: ascSortButton)
            unSelectedSortButtonUI(button: dscSortButton)
        }
        dateSortButton.addAction(dateSortAction, for: .touchUpInside)
        
        let ascSortAction = UIAction { [self] _ in
            self.callRequest(keyword: searchText, sort: .asc)
            selectedSortButtonUI(button: ascSortButton)
            unSelectedSortButtonUI(button: dateSortButton)
            unSelectedSortButtonUI(button: simSortButton)
            unSelectedSortButtonUI(button: dscSortButton)
        }
        ascSortButton.addAction(ascSortAction, for: .touchUpInside)
        
        let dscSortAction = UIAction { [self] _ in
            self.callRequest(keyword: searchText, sort: .dsc)
            selectedSortButtonUI(button: dscSortButton)
            unSelectedSortButtonUI(button: dateSortButton)
            unSelectedSortButtonUI(button: ascSortButton)
            unSelectedSortButtonUI(button: simSortButton)
        }
        dscSortButton.addAction(dscSortAction, for: .touchUpInside)
    }
    
    func selectedSortButtonUI(button: UIButton) {
        button.backgroundColor = UIColor.appDarkGray
        button.setTitleColor(UIColor.appWhite, for: .normal)
    }
    
    func unSelectedSortButtonUI(button: UIButton) {
        button.backgroundColor = UIColor.appWhite
        button.setTitleColor(UIColor.appBlack, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        vmMyShopping = UserDefaultsManager.shared.myShopping
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vcResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as! SearchResultCollectionViewCell
        let data = vcResults[indexPath.item]
        
        cell.vmMyShopping = vmMyShopping
        cell.configureCellUI(item: data)
        cell.item = vcResults[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedData = vcResults[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath) as! SearchResultCollectionViewCell
        
        let vc = SearchResultDetailViewController()
        vc.myShopping = cell.myShopping
        vc.vmMyShopping = cell.vmMyShopping
        vc.item = selectedData
        vc.searchText = String.removeTag(title: selectedData.title)
        vc.configureWebViewUI(link: selectedData.link)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for i in indexPaths {
            if vcResults.count-8 == i.row {
                page += 1
                callRequest(keyword: searchText, sort: sort)
            }
        }
    }
}

extension String {
    static func formatInt(int: String) -> String {
        let i = Int(int)!
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        let result = formatter.string(for: i)!

        return result
    }
}
