//
//  DailyViewController.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 11.04.2023.
//

import UIKit
import CoreData

class DayWeatherViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var index: Int
    var data: [DailyWeather]
    var delegate: DayWeatherViewDelegate?
    init(index: Int, data: [DailyWeather]) {
        self.index = index
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = standardBackgroundColor
        tableView.register(DayWeatherTableViewCell.self, forCellReuseIdentifier: "DayCell")
        tableView.register(SunAndMoonTableViewCell.self, forCellReuseIdentifier: "SunAndMoonCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    var dataByHourFetchResultsController: NSFetchedResultsController<HourlyWeather>?

    func initFetchResultsController() {
        let fetchRequest = HourlyWeather.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "dataByDay == %@", data[self.index])
        dataByHourFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        dataByHourFetchResultsController?.delegate = self
        try? dataByHourFetchResultsController?.performFetch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initFetchResultsController()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            if timeFormat == false {
                formatter.locale = .init(identifier: "ru_RU")
            }
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter
        }()
        
        delegate?.changeTitle(title: "\(dateFormatter.string(from: data[index].date ?? Date()))")
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }

}

extension DayWeatherViewController: UITableViewDataSource, UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as? DayWeatherTableViewCell else {
                preconditionFailure("Error")
            }
            
            cell.data = dataByHourFetchResultsController?.fetchedObjects?[12]
            cell.dateLabel.text = "Day"
            cell.setup()
            return cell
        }
        if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as? DayWeatherTableViewCell else {
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
            cell.data = self.data[self.index]
            cell.setup()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
