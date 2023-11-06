import UIKit
import RealmSwift

class StorageService {
    
    lazy var realm = try! Realm()
    
    init() {
        let configuration = Realm.Configuration(
            schemaVersion: 5,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 5 {
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
}
