//
//  Constants.swift
//  Cocktails
//
//  Created by Aleksei Chupriienko on 25.05.2020.
//  Copyright © 2020 Aleksei Chupriienko. All rights reserved.
//

import Foundation

enum Constants {
    static let apiBaseURL = "https://www.thecocktaildb.com/api/json/v1/1/"
    static let apiFiltersEndpoint = "list.php?c=list"
    static let apiDrinksEndpoint = "filter.php?c="
    static let defaultFilter = "Ordinary Drink"
    static let segueIdentifier = "PresentFilters"
    static let homeControllerCellId = "HomeViewCell"
    static let filtersControllerCellId = "FiltersTableViewCell"
    static let filtersControllerTitle = "Filters"
    static let loadingViewTag = 1234
    static let backButtonImageId = "leftArrow"
}
