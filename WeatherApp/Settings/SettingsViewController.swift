//
//  File.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 11.04.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var locations: [City]
    
    init(locations: [City]) {
        self.locations = locations
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                print(indexPath)
                let location = locations[indexPath.row]
                CoreDataManager.defaultManager.deleteLocation(location: location)
                tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 1)], with: .fade)
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
