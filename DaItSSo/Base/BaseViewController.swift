//
//  BaseViewController.swift
//  DaItSSo
//
//  Created by 김상규 on 6/26/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appWhite
        configureHierarchy()
        configureLayout()
        configureNavigationBar()
        configureView()
    }
    
    func configureNavigationBar() { }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }
}
