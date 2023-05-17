
import UIKit
import CoreData

class PagesViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    private var pageController: UIPageViewController?
    var currentIndex: Int = 0
    var locationFetchResultsController: NSFetchedResultsController<CurrentLocation>?
    private var locations: [CurrentLocation]? {
        return locationFetchResultsController?.fetchedObjects
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initFetchResultsControllers()
        setupPageController()
        setupButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        initFetchResultsControllers()
        title = locations?[currentIndex].name
    }
    
    func initFetchResultsControllers() {
        let firstFetchRequest = CurrentLocation.fetchRequest()

        firstFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]

        locationFetchResultsController = NSFetchedResultsController(fetchRequest: firstFetchRequest, managedObjectContext: CoreDataManager.defaultManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        locationFetchResultsController?.delegate = self
        try? locationFetchResultsController?.performFetch()
    }
    
    private func setupPageController() {
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.view.backgroundColor = .systemBlue
        self.pageController?.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height)
        self.addChild(self.pageController!)
        self.view.addSubview(self.pageController!.view)
        if locations != nil, locations?.count != 0 {
            let initialVC = MainViewController(index: self.currentIndex, locations: locations!)
            self.pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
            self.pageController?.didMove(toParent: self)
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
            CoreDataManager.defaultManager.addData2(data: weatherData as! Weather) { success in
                if success {
                    DispatchQueue.main.async {
                        let vc = PagesViewController()
//                        vc.initFetchResultsControllers()
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
        TextPicker.defaultPicker.getText(showPickerIn: self, title: "Adding a new location", message: "Please enter city name") { text in
            PagesViewController.push(in: self, with: text)
        }
    }
    
}

extension PagesViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        

        if currentIndex == 0 {
            return nil
        }

        currentIndex -= 1

        let vc: MainViewController = MainViewController(index: currentIndex, locations: locations!)
        self.title = locations?[currentIndex].name
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if currentIndex >= (self.locations?.count ?? 0) - 1 {
            return nil
        }
        
        currentIndex += 1
        
        let vc: MainViewController = MainViewController(index: currentIndex, locations: locations!)
        self.title = locations?[currentIndex].name
        return vc
        
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.locations?.count ?? 0
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
}

