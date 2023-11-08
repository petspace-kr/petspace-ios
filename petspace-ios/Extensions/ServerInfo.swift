//
//  ServerInfo.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import Foundation

enum ServerURLCollection: String {
    // 서버 API 주소
    case healthCheck = "https://petspace.whitekiwi.link:3000/health"
    case sendLog = "https://petspace.whitekiwi.link:3000/api-app/v1/logs"
    case getStoreList = "https://petspace.whitekiwi.link:3000/api-app/v1/list-items"
    case getStoreDetail = "https://petspace.whitekiwi.link:3000/api-app/v1/detail"
    
    // test url
    case getTestStoreList = "https://raw.githubusercontent.com/leehe228/SwiftCodingClass/main/dummydata.json"
}

// 서버에 로그를 기록하는 구조체
struct ServerLogger {
    static let urlString = ServerURLCollection.sendLog.rawValue
}
