//
//  MyShopping.swift
//  DaItSSo
//
//  Created by 김상규 on 7/6/24.
//

import Foundation
import RealmSwift


final class MyShopping: Object, Decodable {
    @Persisted(primaryKey: true) var productId: String
    @Persisted(indexed: true) var title: String
    @Persisted var image: String
    @Persisted var mallName: String
    @Persisted var lprice: String
    @Persisted var link: String
    
    convenience init(productId: String, title: String, image: String, mallName: String, lprice: String, link: String) {
        self.init()
        self.productId = productId
        self.image = image
        self.title = title
        self.mallName = mallName
        self.lprice = lprice
        self.link = link
    }

}

final class MyShoppingRepository {
    private let realm = try! Realm()
    
    func loadMyShopping() -> [MyShopping] {
        let result = realm.objects(MyShopping.self)
        
        return Array(result)
    }
    
    func addMyShopping(_ myShopping: MyShopping) {
        do {
            try realm.write {
                realm.add(myShopping)
            }
        } catch {
            print("Realm Error")
        }
    }
    
    func deleteMyShopping(_ myShopping: MyShopping) {
        do {
            try realm.write {
                realm.delete(myShopping)
            }
        } catch {
            print("Realm Error")
        }
    }
}
