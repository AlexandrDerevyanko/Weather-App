
import UIKit
import CoreData
import CoreLocation

class PagesViewController: UIPageViewController, UIPageViewControllerDataSource, NSFetchedResultsControllerDelegate {
    
    private var pageController: UIPageViewController?
    var currentIndex: Int = 0
    private var locationFetchResultsController: NSFetchedResultsController<City>?
    private var locations: [City]? {
        return locationFetchResultsController?.fetchedObjects
    }
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    var latitude: Double?
    var longitude: Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = standardBackgroundColor
        setupButtons()
        initFetchResultsControllers()
        let mainVC = MainViewController.create(index: currentIndex, locations: locations ?? [City()])
        mainVC.delegate = self
        setViewControllers([mainVC], direction: .forward, animated: false)
        self.dataSource = self
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = standardBackgroundColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white.withAlphaComponent(0.8)
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func initFetchResultsControllers() {
        let firstFetchRequest = City.fetchRequest()

        firstFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        locationFetchResultsController = NSFetchedResultsController(fetchRequest: firstFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        locationFetchResultsController?.delegate = self
        try? locationFetchResultsController?.performFetch()
    }
    
    private func setupButtons() {
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(settingsButtonPressed))
        let determinationLocationButton = UIBarButtonItem(image: UIImage(systemName: "location"), style: .plain, target: self, action: #selector(determinationLocationButtonPressed))
        let addLocationButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addLocationButtonPressed))
        
        navigationItem.rightBarButtonItems = [addLocationButton, determinationLocationButton]
        navigationItem.leftBarButtonItem = settingsButton
    }
    
    // Функция добавления и показа новой локации
    static func addAndShowLocation(in viewController: UIViewController, with location: String) {
        DownloadManager.defaultManager.downloadWeatherDataFromString(location: location) { weatherData, error in
            guard let weatherData else { return }
            print(weatherData)
            if let error {
                print(error)
                return
            }
            let data = weatherData as? Weather
            if let data {
                CoreDataManager.defaultManager.addData(data: data) { success in
                    if success {
                        DispatchQueue.main.async {
                            let vc = PagesViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
                            vc.initFetchResultsControllers()
                            vc.currentIndex = 0
                            viewController.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    // Функция определения и показа текущей локации
    private func determinationAndShowLocation(lat: Double, lon: Double) {
        let myLatitude: String = String(format: "%f", lat)
        let myLongitude: String = String(format:"%f", lon)
        DownloadManager.defaultManager.downloadWeatherDataFromCoordinates(lat: myLatitude, lon: myLongitude) { weatherData, error in
            guard let weatherData else { return }
            let data = weatherData as! Weather
            let cityName = data.location?.name
            if cityName == self.locations?[self.currentIndex].name { return }
            let cities = self.locationFetchResultsController?.fetchedObjects
            if let index = cities?.firstIndex(where: {$0.name == cityName}) {
                DispatchQueue.main.async {
                    let pagesVC = PagesViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
                    pagesVC.currentIndex = index
                    
                    self.navigationController?.pushViewController(pagesVC, animated: true)
                }
            } else {
                CoreDataManager.defaultManager.addData(data: data) { success in
                    if success {
                        DispatchQueue.main.async {
                            let vc = PagesViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
                            vc.initFetchResultsControllers()
                            vc.currentIndex = 0
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @objc
    private func settingsButtonPressed() {
        if let locations {
            let settingsVC = SettingsViewController(locations: locations)
            navigationController?.pushViewController(settingsVC, animated: true)
        } 
    }
    
    @objc
    private func addLocationButtonPressed() {
        TextPicker.defaultPicker.getText(showPickerIn: self, title: "Adding a new location", message: "Please enter city name") { text in
            PagesViewController.addAndShowLocation(in: self, with: text)
        }
    }
    
    // Функция определяет название локации устройства и выводит данные о погоде. Если локации не существовало ранее, локация добавляется как новая
    @objc
    private func determinationLocationButtonPressed() {
        if let latitude, let longitude {
            determinationAndShowLocation(lat: latitude, lon: longitude)
        } else {
            AlertPicker.defaulPicker.errors(showIn: self, error: .unexpected)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let index = (viewController as? MainViewController)?.index, index != 0, locations != nil, locations?.count != 0 {
            let mainVC = MainViewController.create(index: index - 1, locations: locations!)
            mainVC.delegate = self
            return mainVC
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let index = (viewController as? MainViewController)?.index, locations != nil, locations?.count != 0, index + 1 < locations!.count {
            let mainVC = MainViewController.create(index: index + 1, locations: locations!)
            mainVC.delegate = self
            return mainVC
        }
        
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.locations?.count ?? 0
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }

}

extension PagesViewController: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        latitude = self.locationManager.location?.coordinate.latitude
        longitude = self.locationManager.location?.coordinate.longitude
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        // Handle failure to get a user’s location
    }
    
}

extension PagesViewController: PagesViewDelegate {
    
    func changeTitle(title: String) {
        self.title = title
    }
}

