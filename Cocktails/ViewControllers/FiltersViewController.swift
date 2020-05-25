//
//  FiltersViewController.swift
//  Cocktails
//
//  Created by Aleksei Chupriienko on 22.05.2020.
//  Copyright © 2020 Aleksei Chupriienko. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate: class {
    func applyFilters(filters: [String])
}

class FiltersViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyButtonOutlet: UIButton!
    
    // MARK: - Public Properties
    
    weak var delegate: FiltersViewControllerDelegate?
    
    //MARK: - Private Properties
    
    private var filters = [Filter]()
    private var selectedFilters: [Filter] {
        filters.filter { $0.isSelected }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        updateData()
    }
   
    //MARK: - Private Methods
    
    private func updateData() {
        setLoadingView()
        CocktailsAPI.shared.fetchFilters { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let filters = response.drinks
                self.filters = filters
                DispatchQueue.main.async {
                    self.removeLoadingView()
                    self.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: error.localizedDescription)
                    self.removeLoadingView()
                }
            }
        }
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - IBActions
    
    @IBAction func applyButtonAction(_ sender: Any) {
        let filters = selectedFilters.map{ $0.name }
        delegate?.applyFilters(filters: filters)
        navigationController?.popViewController(animated: true)
    }
    
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filters[indexPath.row].isSelected = true
        applyButtonOutlet.isEnabled = !selectedFilters.isEmpty
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        filters[indexPath.row].isSelected = false
        applyButtonOutlet.isEnabled = !selectedFilters.isEmpty
    }
    
}

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.filtersControllerCellId, for: indexPath) as? FiltersTableViewCell {
            let filter = filters[indexPath.row]
            cell.label.text = filter.name
            if filter.isSelected {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
            return cell
        }
        return UITableViewCell()
    }
    
}

extension FiltersViewController: Loadable {}
