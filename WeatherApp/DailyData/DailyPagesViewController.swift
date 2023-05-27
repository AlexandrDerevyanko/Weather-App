
import UIKit
import CoreData
import CoreLocation

class DailyPagesViewController: UIPageViewController, UIPageViewControllerDataSource, NSFetchedResultsControllerDelegate {
    
    private var pageController: UIPageViewController?
    var currentIndex: Int
    private var dailyData: [DailyWeather]
    private var hourlyData: [HourlyWeather]
    var hourlyWeatherArray: [HourlyWeather] = []
    
    init(currentIndex: Int, dailyData: [DailyWeather], hourlyData: [HourlyWeather]) {
        self.currentIndex = currentIndex
        self.dailyData = dailyData
        self.hourlyData = hourlyData
            var index = 0
            for i in hourlyData {
                index += 1
                if index % 12 == 0 {
                    hourlyWeatherArray.append(i)
                }
            }
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = standardBackgroundColor
        let dayWeatherVC = DayWeatherViewController(index: currentIndex, dailyData: dailyData, hourlyData: hourlyWeatherArray)
        dayWeatherVC.delegate = self
        setViewControllers([dayWeatherVC], direction: .forward, animated: false)
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
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let index = (viewController as? DayWeatherViewController)?.index, index != Int(0), dailyData.count != Int(0) {
            let dayWatherVC = DayWeatherViewController(index: index - 1, dailyData: dailyData, hourlyData: hourlyWeatherArray)
            dayWatherVC.delegate = self
            return dayWatherVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let index = (viewController as? DayWeatherViewController)?.index, dailyData.count != 0, index + 1 < dailyData.count {
            let dayWatherVC = DayWeatherViewController(index: index + 1, dailyData: dailyData, hourlyData: hourlyWeatherArray)
            dayWatherVC.delegate = self
            return dayWatherVC
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.dailyData.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }

}

extension DailyPagesViewController: DayWeatherViewDelegate {
    
    func changeTitle(title: String) {
        self.title = title
    }
}


