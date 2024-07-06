//
//  MyShoppingListView.swift
//  DaItSSo
//
//  Created by 김상규 on 6/28/24.
//

import UIKit

final class MyShoppingListView: BaseViewController {
    private lazy var noMyShoppingsView = EmptyView()
    private let msr = MyShoppingRepository()
    
    override func configureNavigationBar() {
        navigationItem.title = "나의 장바구니"
    }
    
    override func configureHierarchy() {
        view.addSubview(noMyShoppingsView)
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
    }
    
    override func configureView() {
        noMyShoppingsView.configureEmptyLabel(text: "담은 상품이 없어요\n 쇼핑하러 가볼까요?")
    }
}
