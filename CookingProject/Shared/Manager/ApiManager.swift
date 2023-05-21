//
//  ApiManager.swift
//  CookingProject
//
//  Created by Macbook Air on 16.05.2023.
//

import Foundation

class ApiManager {
    
    private let baseUrl = "https://api.spoonacular.com/recipes/"
    private let apiKey = "075707a3bd0c4f9897594e1cb6eb84d3"
    
    func fetchDetailService(id: String, completion: @escaping(Result<DetailResponseModel, Error>) -> Void) {
        guard let url = URL(string:"\(baseUrl)\(id)/summary?apiKey=\(apiKey)") else { return }
        //"https://api.spoonacular.com/recipes/654959/summary?apiKey=075707a3bd0c4f9897594e1cb6eb84d3"
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            do {
                let responseModel = try JSONDecoder().decode(DetailResponseModel.self, from: data)
                completion(.success(responseModel))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchSearchService(searchText: String, completion: @escaping(Result<SearchResponseModel, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/complexSearch?query=\(searchText)&apiKey=\(apiKey)") else { return }
        //"https://api.spoonacular.com/recipes/complexSearch?query=pasta&apiKey=075707a3bd0c4f9897594e1cb6eb84d3"
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            do {
                let responseModel = try JSONDecoder().decode(SearchResponseModel.self, from: data)
                completion(.success(responseModel))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
