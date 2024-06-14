//
//  IdProtocol.swift
//  DaItSSo
//
//  Created by 김상규 on 6/13/24.
//

import UIKit

protocol setIdentifier {
    static var id: String { get }
}

extension UICollectionViewCell: setIdentifier {
    static var id: String {
        String(describing: self)
    }
}

extension UITableViewCell: setIdentifier {
    static var id: String {
        String(describing: self)
    }
}
