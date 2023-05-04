//
//  DetailsViewCOntroller.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 11.04.2023.
//

import UIKit
import CoreData

class HourlyDataViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var data: DataByDay?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(HourlyDataTableViewCell.self, forCellReuseIdentifier: "HourlyDataCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    var dataByHourFetchResultsController: NSFetchedResultsController<DataByHour>?

    func initFetchResultsController() {
        let fetchRequest = DataByHour.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        if let data {
            fetchRequest.predicate = NSPredicate(format: "dataByDay == %@", data)
        }
        dataByHourFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        dataByHourFetchResultsController?.delegate = self
        try? dataByHourFetchResultsController?.performFetch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFetchResultsController()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initFetchResultsController()
        tableView.reloadData()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBlue
        view.addSubview(tableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }

}

extension HourlyDataViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return HourlyView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataByHourFetchResultsController?.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyDataCell", for: indexPath) as? HourlyDataTableViewCell else {
            preconditionFailure("Error")
        }
        cell.data = dataByHourFetchResultsController?.fetchedObjects?[indexPath.row]
        cell.setup()
        return cell
    }
}


