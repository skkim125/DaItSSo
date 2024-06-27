//
//  UIViewController+Extension.swift
//  DaItSSo
//
//  Created by 김상규 on 6/26/24.
//

import UIKit

extension UIViewController {
    typealias CompletionHandler = ((UIAlertAction) -> ())
    
    func presentTwoActionsAlert(title: String, message: String, act: String, completionHandler: CompletionHandler? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let act = UIAlertAction(title: act, style: .destructive, handler: completionHandler)
        
        alert.addAction(cancel)
        alert.addAction(act)

        present(alert, animated: true)
    }
    
    func presentErrorAlert(searchError: ErrorType.SearchError, completionHandler: CompletionHandler? = nil) {
        let alert = UIAlertController(title: searchError.rawValue , message: nil, preferredStyle: .alert)
        let back = UIAlertAction(title: "확인", style: .default, handler: completionHandler)
        alert.addAction(back)
        self.present(alert, animated: true)
    }
}
