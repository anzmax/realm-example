import UIKit
import RealmSwift

class Quote: Object, Codable {
    @Persisted var value: String
    @Persisted var createdAt: String
    let categories = LinkingObjects(fromType: Category.self, property: "quotes")
    
    private enum CodingKeys: String, CodingKey {
        case value
        case createdAt = "created_at"
    }
}

class Category: Object {
    @Persisted var name: String
    let quotes = List<Quote>()
}
