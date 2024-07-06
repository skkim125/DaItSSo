//
//  MyShopping.swift
//  DaItSSo
//
//  Created by 김상규 on 7/6/24.
//

import Foundation
import RealmSwift


final class MyShoppingModel: Object {
    @Persisted(primaryKey: true) var productId: String
    @Persisted(indexed: true) var title: String
    @Persisted var mallName: String
    @Persisted var lprice: String
    @Persisted var link: String
    
    convenience init(productId: String, title: String, mallName: String, lprice: String, link: String) {
        self.init()
        self.productId = productId
        self.title = title
        self.mallName = mallName
        self.lprice = lprice
        self.link = link
    }

}

final class MyShoppingRepository {
    private let realm = try! Realm()
    
    func loadMyShopping() -> Results<MyShoppingModel>? {
        do {
            try realm.write {
                return realm.objects(MyShoppingModel.self)
            }
        } catch {
            print("Realm Error")
        }
        
        return nil
    }
    
    func addMyShopping(_ myShopping: MyShoppingModel) {
        do {
            try realm.write {
                realm.add(myShopping)
            }
        } catch {
            print("Realm Error")
        }
    }
    
    func deleteMyShopping(_ myShopping: MyShoppingModel) {
        do {
            try realm.write {
                realm.delete(myShopping)
            }
        } catch {
            print("Realm Error")
        }
    }
}
