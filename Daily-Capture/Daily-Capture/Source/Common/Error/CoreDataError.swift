//  Daily-Capture - CoreDataError.swift
//  Created by zhilly, vetto on 2023/07/05

import Foundation

enum CoreDataError: Error {
    case failedFetchEntity
    case invalidObjectID
}

extension CoreDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedFetchEntity:
            return "다이어리 가져오기 실패했습니다."
        case .invalidObjectID:
            return "잘못된 다이어리 ID입니다."
        }
    }
}
