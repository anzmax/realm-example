import UIKit

enum NetworkError: Error {
    case emptyUrl
    case emptyJson
    case parsingInvalid
}

class FetchService {
    
    //https://api.chucknorris.io/jokes/random
    
    func fetchQuote(completion: @escaping (Result<Quote, NetworkError>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.chucknorris.io"
        urlComponents.path = "/jokes/random"
        
        guard let url = urlComponents.url else {
            return completion(.failure(.emptyUrl))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let urlSession = URLSession(configuration: .default)
        urlSession.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                completion(.failure(.emptyJson))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let quote = try jsonDecoder.decode(Quote.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(quote))
                }
            }
            catch {
                print(error)
                completion(.failure(.parsingInvalid))
            }
        }.resume()
    }
    
    func fetchCategories(completion: @escaping (Result<[String], NetworkError>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.chucknorris.io"
        urlComponents.path = "/jokes/categories"
        
        guard let url = urlComponents.url else {
            return completion(.failure(.emptyUrl))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let urlSession = URLSession(configuration: .default)
        urlSession.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.emptyJson))
                return
            }
            
            do {
                let categories = try JSONDecoder().decode([String].self, from: data)
                completion(.success(categories))
            } catch {
                completion(.failure(.parsingInvalid))
            }
        }.resume()
    }
}

