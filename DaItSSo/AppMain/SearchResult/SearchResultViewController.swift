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
    
    var shopping: Shopping = Shopping(total: 0, items: [])
    var results: [Item] = []
    var searchText: String?
    var start = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureNavigationBar()
        if let text = searchText {
            callRequest(keyword: text, sort: SortType.sim)
        }
        configureHierarchy()
        configureLayout()
        configureSortButtons()
    }
    
    func configureNavigationBar() {
        if let text = searchText {
            navigationItem.title = "\(text)"
        }
        
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
            "start": "\(start)",
            "display": "40",
            "sort": "\(sort.rawValue)",
        
        ]
        
        AF.request(url, method: .get, parameters: param, headers: header).responseDecodable(of: Shopping.self) { response in
            switch response.result {
            case .success(let value):
                dump(value)
                self.shopping = value
                self.results = value.items
                self.totalResultLabel.text = "\(value.total)개의 검색결과"
                self.resultCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureSortButtons() {
        if let text = searchText {
            let simSortAction = UIAction { [self] _ in
                self.callRequest(keyword: text, sort: .sim)
                
                selectedSortButtonUI(button: simSortButton)
                unSelectedSortButtonUI(button: dateSortButton)
                unSelectedSortButtonUI(button: ascSortButton)
                unSelectedSortButtonUI(button: dscSortButton)
            }
            simSortButton.addAction(simSortAction, for: .touchUpInside)
            
            let dateSortAction = UIAction { [self] _ in
                self.callRequest(keyword: text, sort: .date)
                selectedSortButtonUI(button: dateSortButton)
                unSelectedSortButtonUI(button: simSortButton)
                unSelectedSortButtonUI(button: ascSortButton)
                unSelectedSortButtonUI(button: dscSortButton)
            }
            dateSortButton.addAction(dateSortAction, for: .touchUpInside)
            
            let ascSortAction = UIAction { [self] _ in
                self.callRequest(keyword: text, sort: .asc)
                selectedSortButtonUI(button: ascSortButton)
                unSelectedSortButtonUI(button: dateSortButton)
                unSelectedSortButtonUI(button: simSortButton)
                unSelectedSortButtonUI(button: dscSortButton)
            }
            ascSortButton.addAction(ascSortAction, for: .touchUpInside)
            
            let dscSortAction = UIAction { [self] _ in
                self.callRequest(keyword: text, sort: .dsc)
                selectedSortButtonUI(button: dscSortButton)
                unSelectedSortButtonUI(button: dateSortButton)
                unSelectedSortButtonUI(button: ascSortButton)
                unSelectedSortButtonUI(button: simSortButton)
            }
            dscSortButton.addAction(dscSortAction, for: .touchUpInside)
        }
    }
    
    func selectedSortButtonUI(button: UIButton) {
        button.backgroundColor = UIColor.appDarkGray
        button.setTitleColor(UIColor.appWhite, for: .normal)
    }
    
    func unSelectedSortButtonUI(button: UIButton) {
        button.backgroundColor = UIColor.appWhite
        button.setTitleColor(UIColor.appBlack, for: .normal)
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.id, for: indexPath) as! SearchResultCollectionViewCell
        let data = results[indexPath.item]
        
        cell.configureCellUI(item: data)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedData = results[indexPath.item]
        
        let vc = SearchResultDetailViewController()
        vc.navigationItem.title = String.removeTag(title: selectedData.title)
        vc.configureWebViewUI(link: selectedData.link)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension Int {
    static func formatInt(int: String) -> String {
        let i = Int(int)!
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        let result = formatter.string(for: i)!

        return result
    }
}
