import UIKit
import RealmSwift

class StorageService {
    
    lazy var realm = try! Realm()
    
    init() {
        let configuration = Realm.Configuration(
            schemaVersion: 11,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 11 {
                }
            }
        )
        Realm.Configuration.defaultConfiguration = configuration
    }
    
    func append(_ quote: Quote) {
        do {
            try realm.write {
                realm.add(quote)
            }
        } catch {
            print("Ошибка при добавлении цитаты в Realm: \(error)")
        }
    }
    
    func load() -> [Quote] {
        let allQuotes = realm.objects(Quote.self)
        return Array(allQuotes)
    }
    
    func delete(quote: Quote) {
        try! realm.write {
            realm.delete(quote)
        }
    }
    
    func appendCategory(category: Category, quote: Quote) {
        
        let existingCategory = realm.objects(Category.self).filter("name == %@", category.name).first
        
        if let existingCategory {
            try! realm.write {
                existingCategory.quotes.append(quote)
            }
        } else {
            category.quotes.append(quote)
            try! realm.write {
                realm.add(category)
            }
        }
    }
}
