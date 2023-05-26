//
//  HourlyView.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 03.05.2023.
//

import UIKit
import SwiftUI

class HourlyWeatherView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let controller = UIHostingController(rootView: WeatherHistory())
        guard let savingsView = controller.view else { return }
        savingsView.backgroundColor = .clear
        savingsView.layer.cornerRadius = 20
        addSubview(savingsView)
        
        savingsView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(20)
            make.bottom.equalTo(-20)
//            make.height.equalTo(170)
        }
    }
    
}
