
import UIKit
import CoreLocation
import CoreData

class MainViewController: UIViewController, NSFetchedResultsControllerDelegate, CLLocationManagerDelegate {
    
    static func create(index: Int, locations: [City]) -> MainViewController {
        return MainViewController(index: index, locations: locations)
    }
    
    init(index: Int, locations: [City]) {
        self.index = index
        self.locations = locations
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static let notificationName = Notification.Name("reloadData")
    var delegate: PagesViewDelegate?
    var index: Int
    var locations: [City]
    private var location: City {
        return locations[index]
    }
    
    private var dailyWeatherFetchResultsController: NSFetchedResultsController<DailyWeather>?
    private var hourlyWeatherFetchResultsController: NSFetchedResultsController<HourlyWeather>? // Для вывода данных в коллекцию начиная с текущего часа
    private var fullHourlyWeatherFetchResultsController: NSFetchedResultsController<HourlyWeather>? // Для передачи данных в подробный прогноз по дням (DayWeatherViewCOntroller)
    private var currentWeatherFetchResultsController: NSFetchedResultsController<CurrentWeather>?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = standardBackgroundColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(DailyWeatherTableViewCell.self, forCellReuseIdentifier: "DaytimeWeatherCell")
        tableView.register(HourlyWeatherCollectionTableViewCell.self, forCellReuseIdentifier: "CollectionCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initFetchResultsControllers()
        setupUI()
        addWeatherHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.changeTitle(title: location.name ?? "")
        reloadData()
    }
    
    func initFetchResultsControllers() {
        let dailyWeatherFetchRequest = DailyWeather.fetchRequest()
        let hourlyWeatherFetchRequest = HourlyWeather.fetchRequest()
        let fullHourlyWeatherFetchRequest = HourlyWeather.fetchRequest()
        let currentWeatherFetchRequest = CurrentWeather.fetchRequest()
        
        dailyWeatherFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        hourlyWeatherFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fullHourlyWeatherFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        currentWeatherFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        dailyWeatherFetchRequest.predicate = NSPredicate(format: "location == %@", location)
        hourlyWeatherFetchRequest.predicate = NSPredicate(format: "location == %@ AND date >= %@", location, Date() as CVarArg)
        fullHourlyWeatherFetchRequest.predicate = NSPredicate(format: "location == %@", location)
        currentWeatherFetchRequest.predicate = NSPredicate(format: "location == %@", location)

        dailyWeatherFetchResultsController = NSFetchedResultsController(fetchRequest: dailyWeatherFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        dailyWeatherFetchResultsController?.delegate = self
        try? dailyWeatherFetchResultsController?.performFetch()
        
        hourlyWeatherFetchResultsController = NSFetchedResultsController(fetchRequest: hourlyWeatherFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        hourlyWeatherFetchResultsController?.delegate = self
        try? hourlyWeatherFetchResultsController?.performFetch()
        
        fullHourlyWeatherFetchResultsController = NSFetchedResultsController(fetchRequest: fullHourlyWeatherFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fullHourlyWeatherFetchResultsController?.delegate = self
        try? fullHourlyWeatherFetchResultsController?.performFetch()
        
        currentWeatherFetchResultsController = NSFetchedResultsController(fetchRequest: currentWeatherFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        currentWeatherFetchResultsController?.delegate = self
        try? currentWeatherFetchResultsController?.performFetch()
    }
    
    @objc
    private func reloadData() {
        tableView.reloadData()
    }
    
    func addWeatherHistory() {
        guard let data = hourlyWeatherFetchResultsController?.fetchedObjects else { return }
        weatherHistoryArray.removeAll()
        var index = 0
        for i in data {
            index += 1
            if index == 24 {
                return
            }
            if index % 3 == 0 {
                weatherHistoryArray.append(WeatherModel(temperature: i.tempC, date: i.date ?? Date()))
            }
            
        }
    }

    private func setupUI() {
        view.backgroundColor = standardBackgroundColor
        view.addSubview(tableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }

}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let cell = MainView()
            let data = currentWeatherFetchResultsController?.fetchedObjects?[0] ?? nil
            cell.data = data
            cell.setup()
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Daily weather forecast"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return dailyWeatherFetchResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 116
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as? HourlyWeatherCollectionTableViewCell else {
                preconditionFailure("Error")
            }
            cell.dataByHour = hourlyWeatherFetchResultsController?.fetchedObjects
            cell.viewController = self
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DaytimeWeatherCell", for: indexPath) as? DailyWeatherTableViewCell else {
            preconditionFailure("Error")
        }
        cell.accessoryType = .disclosureIndicator
        cell.data = dailyWeatherFetchResultsController?.fetchedObjects?[indexPath.row]
        cell.setup()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            if let dailyData = dailyWeatherFetchResultsController?.fetchedObjects, let hourlyData = fullHourlyWeatherFetchResultsController?.fetchedObjects {
                let dailyVC = DailyPagesViewController(currentIndex: indexPath.row, dailyData: dailyData, hourlyData: hourlyData)
                navigationController?.pushViewController(dailyVC, animated: true)
            }
            
        }
    }
    
    
}
