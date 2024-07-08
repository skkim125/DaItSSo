//
//  SearchResultViewController.swift
//  DaItSSo
//
//  Created by 김상규 on 6/14/24.
//

import UIKit
import Alamofire
import Kingfisher
import Reachability
import SnapKit

final class SearchResultViewController: BaseViewController {
    
    lazy var resultCollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.searchResultCollectionViewLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.prefetchDataSource = self
        cv.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.id)
        
        return cv
    }()
    
    private let totalResultLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        label.textColor = .appMainColor
        
        return label
    }()
    
    private let simSortButton = SortButton(sortType: .sim)
    private let dateSortButton = SortButton(sortType: .date)
    private let dscSortButton = SortButton(sortType: .dsc)
    private let ascSortButton = SortButton(sortType: .asc)
    
    private let msr = MyShoppingRepository()
    private let naverShoppingManager = NaverShoppingManager.shared
    private let errorManager = ErrorManager.shared
    
    private let reachability: Reachability = try! Reachability()
    private var sort: SortType = .sim
    private var start = 1
    private var display = 30
    lazy var searchResults: [MyShopping] = []
    var searchText: String = ""
    var totalResults: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        networkReachability()
        getShoppingInfo(starts: self.start)
        configureSortButtons()
    }

    private func networkReachability() {
        do {
            try reachability.startNotifier()
            print("네트워크 연결 정상")
        } catch {
            print("Unable to start notifier")
        }
        
        reachability.whenUnreachable = { _ in
            self.presentErrorAlert(searchError: .networkError) { _ in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func configureNavigationBar() {
        navigationItem.title = SetNavigationTitle.search(searchText).navTitle
        
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
        naverShoppingManager.callRequest(decodableType: Shopping.self, query: searchText, start: starts, sort: sort, display: display) { shopping, error in
            guard error == nil else {
                self.presentErrorAlert(searchError: .networkError) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                return
            }
            
            if let shopping = shopping {
                do {
                    try self.errorManager.checkSearchResults(result: shopping)
                } catch ErrorType.SearchError.isEmptyResult {
                    self.presentErrorAlert(searchError: .isEmptyResult) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                } catch {
                    print(error)
                }
                
                self.totalResults = shopping.total
                self.configureUI(shopping)
                
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
        
        networkReachability()
        resultCollectionView.reloadData()
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        let data = searchResults[indexPath.item]
        
        cell.shopping = data
        cell.configureCellUI(myShopping: data)
        cell.viewController = self
        cell.isAdd = msr.loadMyShopping().contains(where: { $0.productId == data.productId }) ? true : false
        cell.configureSelectButton()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SearchResultCollectionViewCell {
            
            let selectedData = searchResults[indexPath.item]
            let vc = SearchResultDetailViewController()
            
            vc.shopping = selectedData
            vc.image = cell.shoppingImg.image
            vc.isAdd = cell.isAdd
            
            vc.searchText = String.removeTag(title: selectedData.title)
            vc.configureWebViewUI(link: selectedData.link)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if searchResults.count-10 == indexPath.row && totalResults > searchResults.count {
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
        button.isUserInteractionEnabled = false
    }
    
    private func unSelectedSortButtonUI(button: UIButton) {
        button.configuration?.baseForegroundColor = .appDarkGray
        button.configuration?.baseBackgroundColor = .appWhite
        button.isUserInteractionEnabled = true
    }
}
