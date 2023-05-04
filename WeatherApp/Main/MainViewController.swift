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
    
    var currentData: CurrentData? {
        CoreDataManager.defaultManager.currentData[0] 
    }
    var location: CurrentLocation?
    
    var dataByDayFetchResultsController: NSFetchedResultsController<DataByDay>?
    var dataByHourFetchResultsController: NSFetchedResultsController<DataByHour>?

    func initFetchResultsController() {
        let firstFetchRequest = DataByDay.fetchRequest()
        let secondFetchRequest = DataByHour.fetchRequest()
        firstFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        secondFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        if let location {
            firstFetchRequest.predicate = NSPredicate(format: "location == %@", location)
        }
        dataByDayFetchResultsController = NSFetchedResultsController(fetchRequest: firstFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        dataByDayFetchResultsController?.delegate = self
        try? dataByDayFetchResultsController?.performFetch()
        dataByHourFetchResultsController = NSFetchedResultsController(fetchRequest: secondFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        dataByHourFetchResultsController?.delegate = self
        try? dataByHourFetchResultsController?.performFetch()
    }
    
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
        setupUI()
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initFetchResultsController()
        self.title = dataByDayFetchResultsController?.fetchedObjects?[0].location?.name
        tableView.reloadData()
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
    
    static func push(in viewController: UIViewController, with location: String) {
        DownloadManager.defaultManager.downloadWeatherDataFromString(location: location) { weatherData, error in
            guard let weatherData else { return }
            CoreDataManager.defaultManager.addData(data: weatherData as! Weather) { success in
                if success {
                    DispatchQueue.main.async {
                        let vc = MainViewController()
                        viewController.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    @objc
    private func leftButtonPressed() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc
    private func rightButtonPressed() {
        TextPicker.defaultPicker.getText(showPickerIn: self, title: "123", message: "123") { text in
            MainViewController.push(in: self, with: text)
        }
    }

}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let cell = MainView()
            let data = currentData ?? nil
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
            cell.dataByDay = dataByDayFetchResultsController?.fetchedObjects?[0]
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
        if indexPath.section == 1 {
            let dailyVC = DailyViewController()
            dailyVC.data = dataByDayFetchResultsController?.fetchedObjects?[indexPath.row]
            navigationController?.pushViewController(dailyVC, animated: true)
        }
    }
}
