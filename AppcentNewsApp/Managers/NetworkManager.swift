//
//  NetworkManager.swift
//  AppcentNewsApp
//
//  Created by Kadir Hocaoğlu on 13.05.2024.
//

import Foundation

enum APIError: Error {
    case failedToGetData
}


final class NetworkManager {
    static let shared = NetworkManager()

    private init() { }
    
    func getTopHeadlines(completion: @escaping (Result<[Article], Error>) -> Void  ) {
            guard let url: URL = URL(string: "\(baseURL)top-headlines?country=us&\(apiKey)") else {return}
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil  else { return }
                do {
                    let result = try JSONDecoder().decode(NewsResponse.self, from: data)
                    completion(.success(result.articles!))
                }catch {
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
    func getSearch(with query: String, page: Int, pageSize: Int, completion: @escaping (Result<[Article], Error>) -> Void  ) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let offset = (page - 1) * pageSize 
        guard let url: URL = URL(string: "\(baseURL)everything?q=\(query)&pageSize=\(pageSize)&page=\(page)&\(apiKey)") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(NewsResponse.self, from: data)
                guard let articles = result.articles else { return }
                completion(.success(articles))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
}

extension NetworkManager {
    var baseURL: String {
        return getKeys(key: "baseURL")
    }
    
    var apiKey: String {
        return getKeys(key: "apiKey")
    }
}
extension NetworkManager {
    func getKeys(key: String) -> String {
        if let path = Bundle.main.path(forResource: "EnvironmentVariables", ofType: "plist") {
            let key = NSDictionary(contentsOfFile: path)?[key] as? String ?? ""
            return key
        }
        return ""
    }

}
    
