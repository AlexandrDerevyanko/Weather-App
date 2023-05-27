
import UIKit
import CoreData

class DayWeatherViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var index: Int
    var dailyData: [DailyWeather]
    var hourlyData: [HourlyWeather]
    var delegate: DayWeatherViewDelegate?
    init(index: Int, dailyData: [DailyWeather], hourlyData: [HourlyWeather]) {
        self.index = index
        self.dailyData = dailyData
        self.hourlyData = hourlyData
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            if timeFormat == false {
                formatter.locale = .init(identifier: "ru_RU")
            } else {
                formatter.locale = .init(identifier: "en_US")
            }
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter
        }()
        
        delegate?.changeTitle(title: "\(dateFormatter.string(from: dailyData[index].date ?? Date()))")
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
            if self.index == 0 {
                cell.data = hourlyData[0]
                print(hourlyData[0].date)
            } else if self.index == 1 {
                cell.data = hourlyData[2]
                print(hourlyData[2].date)
            } else if self.index == 2 {
                cell.data = hourlyData[4]
                print(hourlyData[4].date)
            }
            cell.dateLabel.text = "Day"
            cell.setup()
            return cell
        }
        if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as? DayWeatherTableViewCell else {
                preconditionFailure("Error")
            }
            if self.index == 0 {
                cell.data = hourlyData[1]
                print(hourlyData[1].date)
            } else if self.index == 1 {
                cell.data = hourlyData[3]
                print(hourlyData[3].date)
            } else if self.index == 2 {
                cell.data = hourlyData[5]
                print(hourlyData[5].date)
            }
            cell.dateLabel.text = "Night"
            cell.setup()
            return cell
        }
        if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SunAndMoonCell", for: indexPath) as? SunAndMoonTableViewCell else {
                preconditionFailure("Error")
            }
            cell.data = self.dailyData[self.index]
            cell.setup()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
