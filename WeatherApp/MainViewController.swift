//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 11.04.2023.
//

import UIKit
import CoreLocation
import CoreData

class MainViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var location: CLLocation?
    
    var fetchResultsController: NSFetchedResultsController<DataByDay>?
    
    func initFetchResultsController(completion: ((_ success: Bool) -> ())) {
        let fetchRequest = DataByDay.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController?.delegate = self
        try? fetchResultsController?.performFetch()
        completion(true)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(DaytimeWeatherTableViewCell.self, forCellReuseIdentifier: "FirstSectionCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initFetchResultsController { success in
            if success {
                self.tableView.reloadData()
            }
        }
        setupUI()
        navigationItem.setHidesBackButton(true, animated: true)
    }

    private func setupUI() {
        view.backgroundColor = .systemBlue
        view.addSubview(tableView)
        setupConstraints()
        setupButtons()
        
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func setupButtons() {
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc
    private func addButtonPressed() {
        
    }

}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let cell = MainView()
//        let data = fetchResultsController?.fetchedObjects?[0] ?? nil
//        cell.data = data
//        cell.setup()
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ежедневный прогноз"
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController?.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FirstSectionCell", for: indexPath) as? DaytimeWeatherTableViewCell else {
            preconditionFailure("Error")
        }
        cell.accessoryType = .disclosureIndicator
        cell.data = fetchResultsController?.fetchedObjects![indexPath.row + 1]
        cell.setup()
        return cell
        
    }
    
}
