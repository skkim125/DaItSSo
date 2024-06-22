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

        view.backgroundColor = .appWhite
        configureNavigationBar()
        naverShoppingManager.callRequest(keyword: searchText, start: start, sort: sort, display: display) { result in
            self.checkResults(result: result)
        }
        configureHierarchy()
        configureLayout()
        configureSortButtons()
    }
    
    func checkResults(result: Result<Shopping, AFError>) {
        
        do {
            try errorManager.checkSearchResults(result: result)
        } catch ErrorType.SearchError.isEmptyResult {
            presentBackAlert(searchError: .isEmptyResult)
        } catch ErrorType.SearchError.networkError {
            presentBackAlert(searchError: .networkError)
        } catch {
            print(error)
        }
        
        self.configureUI(result)
    }
    
    func configureUI(_ result: Result<Shopping, AFError>) {
        self.searchResults = self.naverShoppingManager.returnSearchResults(result: result, start: self.start, searchResults: self.searchResults)
        
        self.totalResultLabel.text = self.naverShoppingManager.returnResultLabelText(result: result)
        self.resultCollectionView.reloadData()
        
        guard !self.searchResults.isEmpty else { return }
        if self.start == 1 {
            self.resultCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
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
    
    func configureSortButtons() {
        simSortButton.configuration?.baseForegroundColor = .appWhite
        simSortButton.configuration?.baseBackgroundColor = .appDarkGray
        
        simSortButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
        dateSortButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
        dscSortButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
        ascSortButton.addTarget(self, action: #selector(sortButtonClicked(_:)), for: .touchUpInside)
    }
    
    @objc func sortButtonClicked(_ sender: UIButton) {
        let buttons = [simSortButton, dateSortButton, dscSortButton, ascSortButton]
        for b in buttons {
            unSelectedSortButtonUI(button: b)
        }
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
        for i in indexPaths {
            if searchResults.count-10 == i.row {
                start += display
                naverShoppingManager.callRequest(keyword: searchText, start: start, sort: .sim, display: display) { result in
                    self.configureUI(result)
                }
            }
        }
    }
}

extension SearchResultViewController {
    
    func sortButtonAction(button: UIButton) {
        switch button.tag {
        case 0:
            start = 1
            naverShoppingManager.callRequest(keyword: searchText, start: start, sort: .sim, display: display) { result in
                self.configureUI(result)
            }
            isSelectedSortButtonUI(button: button)
            
        case 1:
            start = 1
            naverShoppingManager.callRequest(keyword: searchText, start: start, sort: .date, display: display) { result in
                self.configureUI(result)
            }
            isSelectedSortButtonUI(button: button)
            
            return
        case 2:
            start = 1
            naverShoppingManager.callRequest(keyword: searchText, start: start, sort: .dsc, display: display) { result in
                self.configureUI(result)
            }
            isSelectedSortButtonUI(button: button)
            
            return
        case 3:
            start = 1
            naverShoppingManager.callRequest(keyword: searchText, start: start, sort: .asc, display: display) { result in
                self.configureUI(result)
            }
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
