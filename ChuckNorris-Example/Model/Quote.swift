import UIKit
import RealmSwift

class Quote: Object, Codable {
    @Persisted var value: String
    @Persisted var createdAt: String
    
    private enum CodingKeys: String, CodingKey {
        case value
        case createdAt = "created_at"
    }
}

class Category: Object, Codable {
    @Persisted var name: String
    @Persisted var quotes = List<Quote>()
}
