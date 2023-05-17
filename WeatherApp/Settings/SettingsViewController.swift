//
//  File.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 11.04.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private var settings: Settings? {
        return CoreDataManager.defaultManager.settingsData[0]
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.layer.cornerRadius = 20
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBlue
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
        return "Settings"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as? SettingsTableViewCell else {
            preconditionFailure("Error")
        }
        if indexPath.row == 0 {
            cell.title = settingsArray[indexPath.row].title ?? ""
            cell.value = settingsArray[indexPath.row].value ?? []
            cell.setup(text: settingsArray[indexPath.row].title ?? "", value: settingsArray[indexPath.row].value ?? [], boolean: UserDefaults.standard.bool(forKey: settingsArray[indexPath.row].title ?? ""))
        } else if indexPath.row == 1 {
            cell.title = settingsArray[indexPath.row].title ?? ""
            cell.value = settingsArray[indexPath.row].value ?? []
            cell.setup(text: settingsArray[indexPath.row].title ?? "", value: settingsArray[indexPath.row].value ?? [], boolean: UserDefaults.standard.bool(forKey: settingsArray[indexPath.row].title ?? ""))
        }
        return cell
    }
    
    
}
