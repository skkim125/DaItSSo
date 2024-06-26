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

class SearchResultViewController: BaseViewController {
    
    lazy var resultCollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.searchResultCollectionViewLayout())
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
    
    private let userDefaults = UserDefaultsManager.shared
    private let naverShoppingManager = NaverShoppingManager.shared
    private let errorManager = ErrorManager.shared
    private var sort: SortType = .sim
    private var start = 1
    private var display = 30
    lazy var navTitle = SetNavigationTitle.search(searchText)
    var searchResults: [Item] = []
    var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getShoppingInfo(starts: self.start)
        configureSortButtons()
    }

    override func configureNavigationBar() {
        navigationItem.title = navTitle.navTitle
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.backButtonImg, style: .plain, target: self, action: #selector(backButtonClicked))
        navigationController?.navigationBar.tintColor = .appDarkGray
    }
    
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    override func configureHierarchy() {
        view.addSubview(totalResultLabel)
        view.addSubview(simSortButton)
        view.addSubview(dateSortButton)
        view.addSubview(dscSortButton)
        view.addSubview(ascSortButton)
        view.addSubview(resultCollectionView)
    }
    
    override func configureLayout() {
        totalResultLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
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
    
    private func configureSortButtons() {
        simSortButton.configuration?.baseForegroundColor = .appWhite
        simSortButton.configuration?.baseBackgroundColor = .appDarkGray
        
        simSortButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
        dateSortButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
        dscSortButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
        ascSortButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
    }
    
    @objc func sortButtonClicked(_ sender: UIButton) {
        if sender.tag != sort.buttonTag {
            let buttons = [simSortButton, dateSortButton, dscSortButton, ascSortButton]
            for b in buttons {
                unSelectedSortButtonUI(button: b)
            }
            sortButtonAction(button: sender)
        }
    }
    
    private func getShoppingInfo(starts: Int) {
        naverShoppingManager.callRequest(keyword: searchText, start: starts, sort: sort, display: display) { shopping, error in
            
            if let shopping = shopping {
                do {
                    try self.errorManager.checkSearchResults(result: shopping)
                } catch ErrorType.SearchError.isEmptyResult {
                    self.presentBackAlert(searchError: .isEmptyResult) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                } catch {
                    print(error)
                }
                
                self.configureUI(shopping)
                
            } else {
                self.presentBackAlert(searchError: .networkError) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func configureUI(_ result: Shopping) {
        self.searchResults = self.naverShoppingManager.returnSearchResults(result: result, start: self.start, searchResults: self.searchResults)
        
        self.totalResultLabel.text = self.naverShoppingManager.setResultLabelText(result: result)
        self.resultCollectionView.reloadData()
        
        guard !self.searchResults.isEmpty else { return }
        if self.start == 1 {
            self.resultCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        cell.isAdd = userDefaults.myShopping.contains(where: { $0 == data }) ? true : false
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
        for i in indexPaths {
            if searchResults.count-10 == i.row {
                self.start += display
                getShoppingInfo(starts: self.start)
            }
        }
    }
}

extension SearchResultViewController {
    
    private func sortButtonAction(button: UIButton) {
        self.start = 1
        switch button.tag {
        case 0:
            sort = .sim
            getShoppingInfo(starts: self.start)
            isSelectedSortButtonUI(button: button)
            
        case 1:
            sort = .date
            getShoppingInfo(starts: self.start)
            isSelectedSortButtonUI(button: button)
            
            return
        case 2:
            sort = .dsc
            getShoppingInfo(starts: self.start)
            isSelectedSortButtonUI(button: button)
            
            return
        case 3:
            sort = .asc
            getShoppingInfo(starts: self.start)
            isSelectedSortButtonUI(button: button)
            
            return
        default:
            break
        }
    }
    
    private func isSelectedSortButtonUI(button: UIButton) {
        button.configuration?.baseForegroundColor = .appWhite
        button.configuration?.baseBackgroundColor = .appDarkGray
    }
    
    private func unSelectedSortButtonUI(button: UIButton) {
        button.configuration?.baseForegroundColor = .appDarkGray
        button.configuration?.baseBackgroundColor = .appWhite
    }
}
