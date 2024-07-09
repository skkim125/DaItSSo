//
//  Observable.swift
//  DaItSSo
//
//  Created by 김상규 on 7/9/24.
//

import Foundation

class Observable<T> {
    
    var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            self.closure?(self.value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(closure: @escaping (T) -> Void) {
        closure(self.value)
        self.closure = closure
    }
}
