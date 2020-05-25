//
//  CocktailsAPI.swift
//  Cocktails
//
//  Created by Aleksei Chupriienko on 22.05.2020.
//  Copyright © 2020 Aleksei Chupriienko. All rights reserved.
//

import Foundation

class CocktailsAPI {
    static let shared = CocktailsAPI()
    
    //MARK: - Private Properties
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private var components = URLComponents()
    private let baseURL = Constants.apiBaseURL
    private let filtersEndpoint = Constants.apiFiltersEndpoint
    private let drinksEndpoint = Constants.apiDrinksEndpoint
    
    private enum APIError: Error {
        case invalidURL
        case serverDoNotResponse
        case serverResponseError
        case canNotReceiveData
        case filterQueryItemPercentEncodingError
    }
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Public Methods
    
    func fetchFilters(completion: @escaping (Result<FiltersResponse, Error>) -> Void) {
        let filtersURL = baseURL.appending(filtersEndpoint)
        fetchData(from: filtersURL, completion: completion)
    }
    
    func fetchCocktails(filter filterValue: String, completion: @escaping (Result<DrinksResponse, Error>) -> Void) {
        if let filter = filterValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let drinkURL = baseURL.appending(drinksEndpoint).appending(filter)
            fetchData(from: drinkURL, completion: completion)
        } else {
            completion(.failure(APIError.filterQueryItemPercentEncodingError))
        }
    }
    
    //MARK: - Private Methods
    
    private func fetchData<Object: Decodable>(from url: String, completion: @escaping (Result<Object, Error>) -> Void) {
        request(url: url) { (result) in
            switch result {
            case .success(let data):
                do {
                    let object = try self.decoder.decode(Object.self, from: data)
                    completion(.success(object))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func request(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        let task = session.dataTask(with: url) { (data, urlResponse, error) in
            if let error = error {
                completion(.failure(error))
            }
            guard let responseUnwrapped = urlResponse as? HTTPURLResponse else {
                completion(.failure(APIError.serverDoNotResponse))
                return
            }
            switch responseUnwrapped.statusCode {
            case 200:
                guard let data = data else {
                    completion(.failure(APIError.canNotReceiveData))
                    return
                }
                completion(.success(data))
            default:
                completion(.failure(APIError.serverResponseError))
            }
        }
        task.resume()
    }
    
}
