
import UIKit
import CoreData

class PagesViewController: UIPageViewController, UIPageViewControllerDataSource, NSFetchedResultsControllerDelegate {
    
    static let notificationName = Notification.Name("reloadView")
    private var pageController: UIPageViewController?
    var currentIndex: Int = 0
    private var locationFetchResultsController: NSFetchedResultsController<City>?
    private var locations: [City]? {
        return locationFetchResultsController?.fetchedObjects
    }

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
    func addAndShowLocation(in viewController: UIViewController, with location: String) {
        DownloadManager.defaultManager.downloadWeatherDataFromString(location: location) { weatherData, error in
            if let error {
                DispatchQueue.main.async {
                    AlertPicker.defaulPicker.errors(showIn: self, error: error)
                    return
                }
            }
            guard let weatherData else { return }
            let data = weatherData as? Weather
            if let data {
                CoreDataManager.defaultManager.addData(data: data) { success in
                    if success {
                        DispatchQueue.main.async {
                            let pagesVC = PagesViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
                            pagesVC.currentIndex = 0
                            pagesVC.latitude = self.latitude
                            pagesVC.longitude = self.longitude
                            viewController.navigationController?.pushViewController(pagesVC, animated: true)
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
                    pagesVC.latitude = self.latitude
                    pagesVC.longitude = self.longitude
                    self.navigationController?.pushViewController(pagesVC, animated: true)
                }
            } else {
                CoreDataManager.defaultManager.addData(data: data) { success in
                    if success {
                        DispatchQueue.main.async {
                            let pagesVC = PagesViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
                            pagesVC.currentIndex = 0
                            pagesVC.latitude = self.latitude
                            pagesVC.longitude = self.longitude
                            self.navigationController?.pushViewController(pagesVC, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @objc
    private func settingsButtonPressed() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc
    private func addLocationButtonPressed() {
        TextPicker.defaultPicker.getText(showPickerIn: self, title: "Adding a new location", message: "Please enter city name") { text, error in
            if let error {
                AlertPicker.defaulPicker.errors(showIn: self, error: error)
                return
            }
            guard let text else { return }
            self.addAndShowLocation(in: self, with: text)
        }
    }
    
    // Функция определяет название локации устройства и выводит данные о погоде. Если локации не существовало ранее, локация добавляется как новая
    @objc
    private func determinationLocationButtonPressed() {
        if let latitude, let longitude {
            determinationAndShowLocation(lat: latitude, lon: longitude)
        } else {
            AlertPicker.defaulPicker.errors(showIn: self, error: .unexpected)
            return
        }
    }
    
    @objc private func reloadView() {
        let vc = PagesViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        vc.initFetchResultsControllers()
        vc.currentIndex = 0
        self.navigationController?.pushViewController(vc, animated: true)
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

extension PagesViewController: PagesViewDelegate {
    
    func changeTitle(title: String) {
        self.title = title
    }
}

