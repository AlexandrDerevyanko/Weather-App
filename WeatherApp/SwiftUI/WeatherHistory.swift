//
//  WeatherHistory.swift
//  WeatherApp
//
//  Created by Aleksandr Derevyanko on 24.05.2023.
//

import Foundation
import Charts
import SwiftUI

struct WeatherModel: Identifiable {
    let id = UUID()
    let temperature: Double
    let date: Date
}

var weatherHistoryArray: [WeatherModel] = []
var tempFormat: String {
    if temperatureFormat {
        return "ºF"
    } else {
        return "ºC"
    }
}
struct WeatherHistory: View {
    
    func formatDate(_ date: Date) -> String {
//        let cal = Calendar.current
//        let dateComponents = cal.dateComponents ( [.hour, .minute], from: date)
//        guard let hour = dateComponents.hour, let minute = dateComponents.minute else { return "" }
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            if timeFormat == false {
                formatter.locale = .init(identifier: "ru_RU")
            }
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            return formatter
        }()
        return "\(dateFormatter.string(from: date))"
    }
    
    var body: some View {
        Chart(weatherHistoryArray) { weatherModel in
            
            LineMark(x: .value("Time", formatDate(weatherModel.date)),
                     y: .value("Temperature", weatherModel.temperature))
            .interpolationMethod(.cardinal)
            .foregroundStyle(.indigo)
            .symbol(.circle)
            
            PointMark(x: .value("time", formatDate(weatherModel.date)),
                      y: .value("Temperature", weatherModel.temperature))
            .foregroundStyle(.white)
            .symbolSize(10)
        }
//        .chartXAxis {
//            AxisMarks(values: .stride(by: .hour))
//        }
        .chartYAxisLabel("\(tempFormat)")
        .background(Color(.clear))
//        .frame(
//        height: 150
//        )
    }
}
