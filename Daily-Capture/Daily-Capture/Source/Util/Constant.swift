//  Daily-Capture - Constant.swift
//  Created by zhilly, vetto on 2023/08/10

import Foundation

struct Constant {
    static let weatherNameList: [String] = [
        "clear",
        "cloudy-rainny",
        "cloudy-sunny",
        "cloudy",
        "fullmoon",
        "heavyrain-storm",
        "night-rain",
        "night",
        "night-clear",
        "rain",
        "sunny",
        "thunder"
    ]
    
    static let weatherDescription: [String: String] = [
        "clear": "맑음",
        "cloudy-rainny": "흐림 비",
        "cloudy-sunny": "흐림 해",
        "cloudy": "흐림",
        "fullmoon": "보름달",
        "heavyrain-storm": "천둥 번개",
        "night-rain": "밤에 비",
        "night": "밤",
        "night-clear": "맑은 밤",
        "rain": "비",
        "sunny": "해 쨍쨍",
        "thunder": "천둥"
    ]
}
