//
//  MyShoppingListView.swift
//  DaItSSo
//
//  Created by 김상규 on 6/28/24.
//

import UIKit

final class MyShoppingListView: BaseViewController {
    private lazy var noMyShoppingsView = EmptyView()
    lazy var myShoppingsCollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.searchResultCollectionViewLayout())
        cv.backgroundColor = .appWhite
        cv.delegate = self
        cv.dataSource = self
        cv.register(MyShoppingsCollectionViewCell.self, forCellWithReuseIdentifier: MyShoppingsCollectionViewCell.id)
        
        return cv
    }()
    
    private let msr = MyShoppingRepository()
    lazy var myShoppings = msr.loadMyShopping()
    
    override func configureNavigationBar() {
        navigationItem.title = "나의 장바구니"
    }
    
    override func configureHierarchy() {
        view.addSubview(noMyShoppingsView)
        view.addSubview(myShoppingsCollectionView)
    }
    
    override func configureLayout() {
        noMyShoppingsView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(51)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        noMyShoppingsView.emptyImageView.snp.makeConstraints { make in
            make.top.equalTo(noMyShoppingsView.snp.top).offset(30)
            make.horizontalEdges.equalTo(noMyShoppingsView)
            make.height.equalTo(noMyShoppingsView.emptyImageView.snp.width)
        }
        
        noMyShoppingsView.emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(noMyShoppingsView.emptyImageView.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
        }
        
        myShoppingsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        noMyShoppingsView.configureEmptyLabel(text: "담은 상품이 없어요\n 쇼핑하러 가볼까요?")
    }
    
    func setView() {
        noMyShoppingsView.isHidden = myShoppings.isEmpty ? false : true
        myShoppingsCollectionView.isHidden = myShoppings.isEmpty ? true : false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let newShoppings = msr.loadMyShopping()
        myShoppings = newShoppings
        myShoppingsCollectionView.reloadData()
        
        setView()
    }
}

extension MyShoppingListView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myShoppings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyShoppingsCollectionViewCell.id, for: indexPath) as? MyShoppingsCollectionViewCell else { return UICollectionViewCell() }
        let data = myShoppings[indexPath.item]
        
        cell.myShopping = data
        cell.configureCellUI(myShopping: data)
        cell.configureSelectButton()
        cell.viewController = self
        
        return cell
    }
}
