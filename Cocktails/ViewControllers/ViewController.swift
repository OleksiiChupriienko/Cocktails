//
//  ViewController.swift
//  Cocktails
//
//  Created by Aleksei Chupriienko on 22.05.2020.
//  Copyright © 2020 Aleksei Chupriienko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Private Properties
    
    private var drinks: [String: [Drink]] = [:]
    private var filters = [Constants.defaultFilter]
    private var index = 0
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeBackBarButton()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        index = 0
        updateList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == Constants.segueIdentifier, let filtersVC = segue.destination as? FiltersViewController {
            filtersVC.delegate = self
            filtersVC.navigationItem.title = Constants.filtersControllerTitle
        }
    }
    
    //MARK: - Private Methods
    
    private func updateList() {
        setLoadingView()
        if 0..<filters.count ~= index {
            CocktailsAPI.shared.fetchCocktails(filter: filters[index]) { (result) in
                switch result {
                case .success(let response):
                    if self.index == 0 {
                        self.drinks = [:]
                    }
                    let filters = self.filters
                    let index = self.index
                    let key = filters[index]
                    self.drinks[key] = response.drinks
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.removeLoadingView()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(message: error.localizedDescription)
                        self.removeLoadingView()
                    }
                }
            }
        }
    }
    
    private func customizeBackBarButton() {
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: Constants.backButtonImageId)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: Constants.backButtonImageId)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - IBActions
    
    @IBAction func filterButton(_ sender: Any) {
        performSegue(withIdentifier: Constants.segueIdentifier, sender: nil)
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filter = filters[section]
        let sectionDrinks = drinks[filter]
        return sectionDrinks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.homeControllerCellId, for: indexPath) as? HomeViewCell {
            let filter = filters[indexPath.section]
            let sectionDrinks = drinks[filter]
            let drink = sectionDrinks?[indexPath.row]
            cell.label.text = drink?.name
            cell.pictureView.downloaded(from: drink?.imageURL ?? "", contentMode: .scaleToFill)
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        filters.count
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        filters[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == index && indexPath.row == tableView.numberOfRows(inSection: index) - 1 && filters.count - 1 > index {
            index += 1
            updateList()
        }
    }
    
}

extension ViewController: FiltersViewControllerDelegate {
    func applyFilters(filters: [String]) {
        self.filters = filters
    }
    
}

extension ViewController: Loadable {}
