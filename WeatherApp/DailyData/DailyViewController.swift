//
//  DailyViewController.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 11.04.2023.
//

import UIKit
import CoreData

class DailyViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var data: DataByDay?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(DailyTableViewCell.self, forCellReuseIdentifier: "DailyCell")
        tableView.register(SunAndMoonTableViewCell.self, forCellReuseIdentifier: "SunAndMoonCell")
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

extension DailyViewController: UITableViewDataSource, UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataByHourFetchResultsController?.fetchedObjects?.count ?? 0
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as? DailyTableViewCell else {
                preconditionFailure("Error")
            }
            
            cell.data = dataByHourFetchResultsController?.fetchedObjects?[12]
            cell.dateLabel.text = "Day"
            cell.setup()
            return cell
        }
        if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as? DailyTableViewCell else {
                preconditionFailure("Error")
            }
            
            cell.data = dataByHourFetchResultsController?.fetchedObjects?[23]
            cell.dateLabel.text = "Night"
            cell.setup()
            return cell
        }
        if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SunAndMoonCell", for: indexPath) as? SunAndMoonTableViewCell else {
                preconditionFailure("Error")
            }
            cell.data = self.data
            cell.setup()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
