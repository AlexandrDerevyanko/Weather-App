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
    
    var index: Int
    var locations: [CurrentLocation]
    var location: CurrentLocation {
        return locations[index]
    }
    
    init(index: Int, locations: [CurrentLocation]) {
        self.index = index
        self.locations = locations
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var dataByDayFetchResultsController: NSFetchedResultsController<DataByDay>?
    var dataByHourFetchResultsController: NSFetchedResultsController<DataByHour>?
    var currentDataFetchResultsController: NSFetchedResultsController<CurrentData>?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(DaytimeWeatherTableViewCell.self, forCellReuseIdentifier: "DaytimeWeatherCell")
        tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: "CollectionCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initFetchResultsControllers()
        setupUI()
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = location.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGray6
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func initFetchResultsControllers() {
        let firstFetchRequest = DataByDay.fetchRequest()
        let secondFetchRequest = DataByHour.fetchRequest()
        let thirdFetchRequest = CurrentData.fetchRequest()
        
        firstFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        secondFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        thirdFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        firstFetchRequest.predicate = NSPredicate(format: "location == %@", location)
        secondFetchRequest.predicate = NSPredicate(format: "location == %@", location)
        thirdFetchRequest.predicate = NSPredicate(format: "location == %@", location)

        dataByDayFetchResultsController = NSFetchedResultsController(fetchRequest: firstFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        dataByDayFetchResultsController?.delegate = self
        try? dataByDayFetchResultsController?.performFetch()
        
        dataByHourFetchResultsController = NSFetchedResultsController(fetchRequest: secondFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        dataByHourFetchResultsController?.delegate = self
        try? dataByHourFetchResultsController?.performFetch()
        
        currentDataFetchResultsController = NSFetchedResultsController(fetchRequest: thirdFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        currentDataFetchResultsController?.delegate = self
        try? currentDataFetchResultsController?.performFetch()
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
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(leftButtonPressed))
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "location"), style: .plain, target: self, action: #selector(rightButtonPressed))
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc
    private func leftButtonPressed() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc
    private func rightButtonPressed() {
        
    }

}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let cell = MainView()
            let data = currentDataFetchResultsController?.fetchedObjects?[0] ?? nil
            cell.data = data
            cell.setup()
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ежедневный прогноз"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return dataByDayFetchResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 116
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as? CollectionTableViewCell else {
                preconditionFailure("Error")
            }
            cell.dataByHour = dataByHourFetchResultsController?.fetchedObjects
            cell.viewController = self
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DaytimeWeatherCell", for: indexPath) as? DaytimeWeatherTableViewCell else {
            preconditionFailure("Error")
        }
        cell.accessoryType = .disclosureIndicator
        cell.data = dataByDayFetchResultsController?.fetchedObjects?[indexPath.row]
        cell.setup()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            print(indexPath.row)
            let dailyVC = DailyViewController()
            dailyVC.data = dataByDayFetchResultsController?.fetchedObjects?[indexPath.row]
//            print(dataByDayFetchResultsController?.fetchedObjects?[indexPath.row].date)
            navigationController?.pushViewController(dailyVC, animated: true)
        }
    }
}
