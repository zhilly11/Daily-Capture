//  Daily-Capture - WeatherPickerViewModel.swift
//  Created by zhilly, vetto on 2023/07/28

import RxSwift

final class WeatherPickerViewModel {
    let weatherText: BehaviorSubject<String> = .init(value: "clear")
    
    var weatherImage: UIImage? {
        get {
            return UIImage(named: getWeatherString())
        }
    }
    
    private func getWeatherString() -> String {
        do {
            return try weatherText.value()
        } catch {
            print("error")
        }
        
        return ""
    }
}
