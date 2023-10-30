//  Daily-Capture - Constant.swift
//  Created by zhilly, vetto on 2023/08/10

import Foundation

struct Constant {
    static let weatherNameList: [String] = [
        "clear",
        "sunny",
        "cloudy-sunny",
        "cloudy-rainny",
        "cloudy",
        "fullmoon",
        "night",
        "night-clear",
        "night-rain",
        "rain",
        "thunder",
        "heavyrain-storm"
    ]
    
    static let weatherDescription: [String: String] = [
        "clear": "맑음",
        "sunny": "흐린뒤 맑음",
        "cloudy-sunny": "약간 흐림",
        "cloudy-rainny": "흐린뒤 비",
        "cloudy": "흐림",
        "fullmoon": "보름달",
        "night": "흐린 밤",
        "night-clear": "맑은 밤",
        "night-rain": "밤에 비옴",
        "rain": "비",
        "thunder": "천둥",
        "heavyrain-storm": "천둥 번개"
    ]
}
