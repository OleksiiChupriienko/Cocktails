//
//  APIResponse.swift
//  Cocktails
//
//  Created by Aleksei Chupriienko on 23.05.2020.
//  Copyright © 2020 Aleksei Chupriienko. All rights reserved.
//

import Foundation

struct DrinksResponse: Codable {
    let drinks: [Drink]
}

struct FiltersResponse: Codable {
    let drinks: [Filter]
}

struct Drink: Codable {
    let name: String
    let imageURL: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strDrink"
        case imageURL = "strDrinkThumb"
        case id = "idDrink"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        imageURL = try container.decode(String.self, forKey: .imageURL)
        id = try container.decode(String.self, forKey: .id)
    }
}

struct Filter: Codable {
    let name: String
    var isSelected: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case name = "strCategory"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }
}
