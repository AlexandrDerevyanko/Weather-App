
import Foundation

class SettingsData {
    
    var title: String?
    var value: [String]?
    var isBool: Bool?
    var action: (() -> Void)?
    
    init(title: String? = "", value: [String]? = nil, isBool: Bool? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.value = value
        self.isBool = isBool
        self.action = action
    }
    
}

var settingsArray: [SettingsData] = [
    SettingsData(title: "Temperature", value: ["C", "F"]),
    SettingsData(title: "Time format", value: ["12", "24"])
]
