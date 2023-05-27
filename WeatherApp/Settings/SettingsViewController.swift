//
//  File.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 11.04.2023.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController, NSFetchedResultsControllerDelegate {
        
    var locations: [City] {
        initCityFetchResultsController()
        return cityFetchResultsController?.fetchedObjects ?? []
    }
    private var cityFetchResultsController: NSFetchedResultsController<City>?
    private var dailyWeatherFetchResultsController: NSFetchedResultsController<DailyWeather>?
    private var hourlyWeatherFetchResultsController: NSFetchedResultsController<HourlyWeather>?
    private var currentWeatherFetchResultsController: NSFetchedResultsController<CurrentWeather>?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.layer.cornerRadius = 20
        tableView.backgroundColor = .systemGray5.withAlphaComponent(0.6)
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(LocationsTableViewCell.self, forCellReuseIdentifier: "LocationsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initCityFetchResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Settings"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = standardBackgroundColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white.withAlphaComponent(0.8)
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        tableView.reloadData()
    }
    
    @objc private func backButtonPressed() {
        let pagesVC = PagesViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        navigationController?.pushViewController(pagesVC, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = standardBackgroundColor
        view.addSubview(tableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.bottom.equalTo(-100)
        }
    }
    
    func initCityFetchResultsController() {
        let cityFetchRequest = City.fetchRequest()
        
        cityFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        cityFetchResultsController = NSFetchedResultsController(fetchRequest: cityFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        cityFetchResultsController?.delegate = self
        do {
            try cityFetchResultsController?.performFetch()
        } catch {
            print(error)
        }
    }
    
    func initFetchResultsControllers(location: City, completion: ((_ success: Bool) -> ())?) {
        let dailyWeatherFetchRequest = DailyWeather.fetchRequest()
        let hourlyWeatherFetchRequest = HourlyWeather.fetchRequest()
        let currentWeatherFetchRequest = CurrentWeather.fetchRequest()
        
        dailyWeatherFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        hourlyWeatherFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        currentWeatherFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        dailyWeatherFetchRequest.predicate = NSPredicate(format: "location == %@", location)
        hourlyWeatherFetchRequest.predicate = NSPredicate(format: "location == %@", location)
        currentWeatherFetchRequest.predicate = NSPredicate(format: "location == %@", location)

        dailyWeatherFetchResultsController = NSFetchedResultsController(fetchRequest: dailyWeatherFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        dailyWeatherFetchResultsController?.delegate = self
        try? dailyWeatherFetchResultsController?.performFetch()
        
        hourlyWeatherFetchResultsController = NSFetchedResultsController(fetchRequest: hourlyWeatherFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        hourlyWeatherFetchResultsController?.delegate = self
        try? hourlyWeatherFetchResultsController?.performFetch()
        
        currentWeatherFetchResultsController = NSFetchedResultsController(fetchRequest: currentWeatherFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        currentWeatherFetchResultsController?.delegate = self
        try? currentWeatherFetchResultsController?.performFetch()
        
        do {
            try dailyWeatherFetchResultsController?.performFetch()
            try hourlyWeatherFetchResultsController?.performFetch()
            try currentWeatherFetchResultsController?.performFetch()
            completion?(true)
        } catch {
            print(error)
            completion?(false)
        }
    }

    private func updateView() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonPressed))
        backButton.tintColor = .white.withAlphaComponent(0.8)
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Settings"
        }
        return "Locations"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as? SettingsTableViewCell else {
                preconditionFailure("Error")
            }
            if indexPath.row == 0 {
                cell.title = "Temperature"
                cell.value = ["°C", "°F"]
                cell.boolean = temperatureFormat
                cell.setup()
            } else if indexPath.row == 1 {
                cell.title = "Time format"
                cell.value = ["24", "12"]
                cell.boolean = timeFormat
                cell.setup()
            }
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationsCell", for: indexPath) as? LocationsTableViewCell else {
            preconditionFailure("Error")
        }
        cell.setup(cityLabelText: locations[indexPath.row].name ?? "")
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        }
        return false
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if editingStyle == .delete {
                let location = locations[indexPath.row]
                initFetchResultsControllers(location: location) { [self] success in
                    if success {
                        guard let dailyWeather = dailyWeatherFetchResultsController?.fetchedObjects, let hourlyWeather = hourlyWeatherFetchResultsController?.fetchedObjects, let currentWeather = currentWeatherFetchResultsController?.fetchedObjects else { return }
                        CoreDataManager.defaultManager.deleteData(location: location, dailyWeather: dailyWeather, hourlyWeather: hourlyWeather, currentWeather: currentWeather[0])
                        tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 1)], with: .fade)
                        updateView()
                    }
                }
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let pagesVC = PagesViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            pagesVC.currentIndex = indexPath.row
            navigationController?.pushViewController(pagesVC, animated: true)
        }
    }
    
    
}
